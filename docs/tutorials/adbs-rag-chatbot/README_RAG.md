# RAG Chatbot engine with Oracle Database 23ai on Google Cloud Platform

In this part of the blog we will teach you how you can implement a **RAG (Retrieval Augmented Generation)** chatbot using vector similarity search and Generative AI / LLMs.

We will guide you through the process of loading and parsing a FAQ-like text file, integrating it with an Oracle 23ai database, and employing the Google Cloud Platform to order it and run the Python glue code and Generative AI services needed for the chatbot.

**TLDR:** With this tutorial, you'll learn how to:

- Implement a RAG chatbot using vector similarity search and Generative AI/LLMs
- Load and parse a FAQ-like text file, integrating it with an Oracle 23ai database
- Employ the Google Cloud Platform to order and run the Python glue code and Generative AI services needed for the chatbot
- Use the Oracle Database 23ai vector database to store and retrieve relevant information
- Leverage the Gemini Generative AI service to generate high-quality responses to user queries

## Setup the working environment in Google Cloud

The prerequisites needed to run this notebook are described [here](README.md)

In a nutshell, we need:

- Google Cloud tenancy
- Oracle Database 23ai marketplace subscription
- Linux (Ubuntu) virtual machine
- Access to Google's Gemini generative AI service

## Setup the Python environment

For this tutorial, we will use Visual Studio Code (VSCode) to connect to our Ubuntu VM on Google Cloud and run all the configuration steps, edit, and run our Jupyter Notebook.

Please use VSCode's Remote Explorer function to connect to your remote VM. If you don't know how to do that, please see [this tutorial first](https://code.visualstudio.com/docs/remote/ssh).

Next, install `pyenv` on the remote machine. This is our way to quickly and neatly manage multiple Python versions on the same machine. For this
tutorial, we will use Python 3.12. If you are more comfortable with other ways to install the desired Python version on a Linux box, feel free to use it instead.

Open the terminal pane in VSCode and run the following commands (for the latest version of this procedure, see [the official pyenv page here](https://github.com/pyenv/pyenv-installer)):

```bash
# Install dependencies
sudo apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev libffi-dev liblzma-dev python3-openssl git

# Download and install pyenv
curl https://pyenv.run | bash

# Configure pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile
echo 'eval "$(pyenv init -)"' >> ~/.profile

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc

# Reload shell configuration
exec "$SHELL"

# Install Python 3.12 using pyenv
pyenv install 3.12

# Create a new directory for the project
mkdir vectors

# Change into the new directory
cd vectors

# Make Python 3.12 the active kernel
pyenv local 3.12

# Install required libraries
pip install oracledb
pip install sentence-transformers
```

Open the `vectors.ipynb` file (this file, really) in VSCode and continue reading while executing the code cells below.

## Generate vector embeddings

This section guides you through the code required to load text files from a local folder, split them into segments, and then create embeddings and ingest them into the Oracle 23ai vector database

### Concepts

- What is a Vector?

A vector is like a fingerprint for information. Just like every person's fingerprint is unique and gives us lots of details about them, a vector in AI is a unique set of numbers representing the important semantic features of a piece of information, like a block of text, an image, a sound, or a video.

- What is Similarity Search and Outlier Search?

A similarity search helps you find semantically similar things, like Google or Bing does, by computing the shortest distance between two vectors. But imagine being able to do that in the database, with text, audio, image, and video files and the full power of SQL and PL/SQL at your disposal. An outlier search does the opposite: it retrieves the least similar results.

- What is a LLM?

LLMs, or Large Language Models, are AI neural networks that use large data sets to understand, summarize, generate, and predict new content. Oracle AI Vector Search works well with any Large Language Model \[LLM\] and vector embedding model.

- What is RAG?

Retrieval Augmented Generation (RAG) is a technique that enhances LLMs by integrating Similarity Search. This enables use cases such as a corporate chatbot responding with private company knowledge to make sure it's giving answers that are up-to-date and tailored to your business.

### Task 1: Loading the text sources from a file.

Let's work with our source files, which contain the knowledge we want to use as the foundation for our chatbot's responses. FAQs are loaded from a file, encoded, and stored. For this example, we will use a properly formatted plain text FAQ, following the pattern:

```text
What is Oracle Cloud Free Tier?

Oracle Cloud Free Tier allows you to sign up for an Oracle Cloud account which provides a number of Always Free services and a Free Trial with US$300 of free credit to use on all eligible Oracle Cloud Infrastructure services for up to 30 days. The Always Free services are available for an unlimited period of time. The Free Trial services may be used until your US$300 of free credits are consumed or the 30 days has expired, whichever comes first.

=====

Who should use Oracle Cloud Free Tier?

Oracle Cloud Free Tier services are for everyone. Whether you’re a developer building and testing applications, a startup founder creating new systems with the intention of scaling later, an enterprise looking to test things before moving to cloud, a student wanting to learn, or an academic developing curriculum in the cloud, Oracle Cloud Free Tier enables you to learn, explore, build and test for free.

=====

Why do I need to provide credit or debit card information when I sign up for Oracle Cloud Free Tier?

To provide free Oracle Cloud accounts to our valued customers, we need to ensure that you are who you say you are. We use your contact information and credit/debit card information for account setup and identity verification. Oracle may periodically check the validity of your card, resulting in a temporary “authorization” hold. These holds are removed by your bank, typically within three to five days, and do not result in actual charges to your account.

=====
```

So, we have the question, an empty line, the answer, and then a separator denoted by =====. For this simple example, we load the whole thing into memory. For a small FAQ file, there is no need for a proper vector database; however, if your knowledge base grows, you will want one.

The function below will open all the .txt files in a specified folder, read them, split the content using the ======== separator. It will then put all the resulting chunks in an array.

The array is stored inside a dictionary with the file name used as the key. This will be useful later if many other FAQ files are available inside the folder, helping to differentiate between the sources.

```python
import os

def loadFAQs(directory_path):
    """
    Loads FAQs from a file and returns a dictionary with file names as keys and lists of FAQs as values.
    
    Parameters:
    directory_path (str): Path to the directory containing the FAQ files.
    
    Returns:
    dict: Dictionary with file names as keys and lists of FAQs as values.
    """
    faqs = {}

    for filename in os.listdir(directory_path):
        if filename.endswith(".txt"):  # assuming FAQs are in .txt files
            file_path = os.path.join(directory_path, filename)

            with open(file_path) as f:
                raw_faq = f.read()

            filename_without_ext = os.path.splitext(filename)[0]  # remove .txt extension
            faqs[filename_without_ext] = [text.strip() for text in raw_faq.split('=====')]

    return faqs

faqs = loadFAQs('.')
```

The final step in preparing the source data is to arrange the above dictionary in a way that is easy to ingest in the vector database. Enter this code into a new cell.

```python
docs = [{'text': filename + ' | ' + section, 'path': filename} for filename, sections in faqs.items() for section in sections]

# Sample the resulting data
docs[:2]
[{'text': 'faq | Who are you and what can you do?\n\nI am DORA, the Digital ORacle Assistant, a digital assistant working for Oracle EMEA. I can answer questions about Oracle Cloud (OCI) and especially about the Free Trial and Always Free programs.',
    'path': 'faq'},
    {'text': 'faq | What is Oracle Cloud Free Tier?\n\nOracle Cloud Free Tier allows you to sign up for an Oracle Cloud account which provides a number of Always Free services and a Free Trial with US$300 of free credit to use on all eligible Oracle Cloud Infrastructure services for up to 30 days. The Always Free services are available for an unlimited period of time. The Free Trial services may be used until your US$300 of free credits are consumed or the 30 days has expired, whichever comes first.',
    'path': 'faq'}]
```

### Task 2: Loading the FAQ chunks into the vector database

Make sure you downloaded the wallet file from the database's cloud console page, as described in the prerequisites. Upload it to the remote VM in VSCode and place it in the folder above the `vectors` folder. (Or anywhere else, but be sure to update the path to the wallet twice in the cell below.)

Also, replace the username and password for the wallet and the database user in the cell too.

```python
import oracledb

un = "user"
pw = "password"
dsn = “<ReplaceWithYourWallet>_high”

connection = oracledb.connect(
    config_dir = '../wallet', # path to your wallet
    user=un, 
    password=pw, 
    dsn=dsn,
    wallet_location = '../wallet',
    wallet_password = 'password')
```

Let's create the `faqs` table. We need a table inside our database to store our vectors and metadata.

```python
table_name = 'faqs'

with connection.cursor() as cursor:
    # Create the table
    create_table_sql = f"""
        CREATE TABLE IF NOT EXISTS {table_name} (
            id NUMBER PRIMARY KEY,
            payload CLOB CHECK (payload IS JSON),
            vector VECTOR
        )"""
    try:
        cursor.execute(create_table_sql)
    except oracledb.DatabaseError as e:
        raise

    connection.autocommit = True
```

To vectorize the text chunks from the FAQ file, we need an encoder to handle the vectorization for us.

```python
from sentence_transformers import SentenceTransformer
encoder = SentenceTransformer('all-MiniLM-L12-v2')
```

We go through all our chunks (stored in the docs dictionary) and encode the text content.

```python
import array

# Define a list to store the data
data = [
    {"id": idx, "vector_source": row['text'], "payload": row} 
    for idx, row in enumerate(docs)
]

# Collect all texts for batch encoding
texts = [f"{row['vector_source']}" for row in data]

# Encode all texts in a batch
embeddings = encoder.encode(texts, batch_size=32, show_progress_bar=True)

# Assign the embeddings back to your data structure
for row, embedding in zip(data, embeddings):
    row['vector'] = array.array("f", embedding)
Batches: 100%|██████████| 7/7 [00:18<00:00,  2.69s/it]
```

That's it, now we have a structure with all our chunks, including its context --- the source file name, in this simple example --- and the vector representation for each of them.

Next step is about inserting the chunks + vectors in the database.

Initially, we use a cursor object from the established database connection (basically, a database operator) to execute a command that truncates the specified table. This operation ensures that all existing rows are removed, effectively resetting the table to an empty state and preparing it for fresh data insertion.

Subsequently, the code prepares a list of tuples containing the new data. Each tuple includes an id, a JSON-encoded payload, and a vector.

The `json.dumps` function is used to convert the payload into a JSON string format, ensuring that complex data structures are properly serialized for database storage.

We then utilize the `cursor.executemany` method to insert all prepared tuples into the table in a single batch operation. This method is highly efficient for handling bulk inserts, significantly reducing the number of database transactions and improving performance. Finally, the `connection.commit` method is called to commit the transaction, ensuring that all changes are saved and made permanent in the database.

```python
import json

with connection.cursor() as cursor:
    # Truncate the table
    cursor.execute(f"truncate table {table_name}")

    prepared_data = [(row['id'], json.dumps(row['payload']), row['vector']) for row in data]

    # Insert the data
    cursor.executemany(
        f"""INSERT INTO {table_name} (id, payload, vector)
        VALUES (:1, :2, :3)""",
        prepared_data
    )

    connection.commit()
```

Just to confirm, let's examine what is currently stored in our table.

```python
with connection.cursor() as cursor:
    # Define the query to select all rows from a table
    query = f"SELECT * FROM {table_name}"

    # Execute the query
    cursor.execute(query)

    # Fetch all rows
    rows = cursor.fetchall()

    # Print the rows
    for row in rows[:5]:
        print(row)
```

We can also use the SQL Developer plugin to view the data stored in our table. Open the FAQS table in the plugin window and click on the Data tab.

At this point, our database contains all our knowledge base, so we are ready to proceed to the next step, basing it on users' questions.

## Vector retrieval and Large Language Model generation

This section guides you through the steps to integrate the vector database (Oracle Database 23ai in our case) and retrieve a list of text chunks that are close to the "question" in vector space. Then, we will use the most relevant text chunks to create an LLM prompt and ask the Gemini Generative AI service to create a nicely worded response for us.

This is a classical Retrieval-Augmented Generation (RAG) approach. The Retrieval-Augmented Generation architecture combines retrieval-based and generation-based methods to enhance natural language processing tasks. It consists of a retriever, which searches a knowledge base for relevant documents (that have been disassembled and put into vectors), and a generator, which uses these documents to produce informed responses. This dual approach improves accuracy and detail compared to models relying solely on pre-trained knowledge.

The retriever finds the most pertinent documents by embedding both queries and documents into the same vector space. This ensures that the top-N relevant documents are selected to provide additional context for the generator. By doing so, the retriever enhances the quality of the generated text, particularly for queries needing specific or up-to-date
information.

The generator integrates the retrieved documents into its response generation. It may concatenate the query with the retrieved texts or use attention mechanisms to focus on relevant parts, producing coherent and contextually rich responses. This combination allows RAG to handle diverse tasks, making it a versatile tool in natural language processing.

### Vectorize the "question"

In this step, we will take a text, supposedly the question the user is asking to the bot, and transform it into a vector (vectorize it). We will then insert this vector into the database, where it will be used to retrieve similar vectors and associated metadata, which are stored in the database.

Let's define the SQL script used to retrieve the chunks

```python
topK = 3

sql = f"""select payload, vector_distance(vector, :vector, COSINE) as score
from {table_name}
order by score
fetch approx first {topK} rows only"""
```

In the given SQL query, `topK` represents the number of top results to retrieve. The query selects the payload column along with the cosine distance between the vector column in the specified table `table_name` and a provided vector parameter `:vector`, aliasing the distance calculation as `score`.

By ordering the results by the calculated score and using fetch approx first `topK` rows only, the query efficiently retrieves only the top `topK` results based on their cosine similarity to the provided vector.

We transform this question into a vector.

`question = 'What is Always Free?'`

We employ the same encoder as in previous text chunks, generating a vector representation of the question.

```python
with connection.cursor() as cursor:
    embedding = list(encoder.encode(question))
    vector = array.array("f", embedding)

    results  = []

    for (info, score, ) in cursor.execute(sql, vector=vector):
        text_content = info.read()
        results.append((score, json.loads(text_content)))
```

The SQL query is executed with the provided vector parameter, fetching relevant information from the database. For each result, the code retrieves the text content, stored in JSON format, and appends it to a list along with the calculated similarity score. This process iterates through all fetched results, accumulating them in the results list.

If we print the results, we obtain something like the following. As requested, we have the "score" of each hit, which is essentially the distance in vector space between the question and the text chunk, as well as the metadata JSON embedded in each chunk. The higher the score, the closer the vectors are, which means that the generator will be able to produce a higher-quality response with this vector.

```python
import pprint
pprint.pp(results)
[(0.3420591950416565,
    {'text': 'faq | What are Always Free services?\n'
            '\n'
            'Always Free services are part of Oracle Cloud Free Tier. Always '
            'Free services are available for an unlimited time. Some '
            'limitations apply. As new Always Free services become available, '
            'you will automatically be able to use those as well.\n'
            '\n'
            'The following services are available as Always Free:\n'
            '\n'
            'AMD-based Compute\n'
            'Arm-based Ampere A1 Compute\n'
            'Block Volume\n'
            'Object Storage\n'
            'Archive Storage\n'
            'Flexible Load Balancer\n'
            'Flexible Network Load Balancer\n'
            'VPN Connect\n'
            'Autonomous Data Warehouse\n'
            'Autonomous Transaction Processing\n'
            'Autonomous JSON Database\n'
            'NoSQL Database (Phoenix Region only)\n'
            'APEX Application Development\n'
            'Resource Manager (Terraform)\n'
            'Monitoring\n'
            'Notifications\n'
            'Logging\n'
            'Application Performance Monitoring\n'
            'Service Connector Hub\n'
            'Vault\n'
            'Bastions\n'
            'Security Advisor\n'
            'Virtual Cloud Networks\n'
            'Site-to-Site VPN\n'
            'Content Management Starter Edition\n'
            'Email Delivery',
    'path': 'faq'}),
    (0.4832669496536255,
    {'text': 'faq | Are Always Free services available for paid accounts?\n'
            '\n'
            'Yes, for paid accounts using universal credit pricing.',
    'path': 'faq'}),
    (0.4878004789352417,
    {'text': 'faq | Could you elaborate on the concept of Always Free resources '
            'in Oracle Cloud Infrastructure, and how can users leverage them '
            'for various use cases while staying within the specified '
            'limitations?\n'
            '\n'
            'Always Free resources in Oracle Cloud Infrastructure are services '
            'and resources that can be used without incurring charges, subject '
            'to certain usage limitations. Users can leverage these resources '
            'for development, testing, small-scale applications, and learning '
            'purposes, all while adhering to the restrictions outlined in the '
            'terms and conditions.',
    'path': 'faq'})]
```

### Create the LLM prompt

In a Retrieval-Augmented Generation (RAG) application, the prompt given to a Large Language Model (LLM) is crucial for ensuring that the model generates accurate and contextually relevant responses. It effectively integrates retrieved information with the query, clarifies user intent, and frames the context in which the LLM operates. A well-crafted prompt enhances the relevance and accuracy of the generated text by providing clear instructions and integrating various aspects of the retrieved data. This is essential for optimizing performance, handling complex queries, and delivering precise and user-satisfactory outputs in real-time applications.  
Before sending anything to the LLM, we must ensure that our prompt does not exceed the maximum context length of the model. A smaller context length also ensures faster responses, usually.

```python
from transformers import LlamaTokenizerFast
import sys

tokenizer = LlamaTokenizerFast.from_pretrained("hf-internal-testing/llama-tokenizer")


tokenizer.model_max_length = sys.maxsize

def truncate_string(string, max_tokens):
    # Tokenize the text and count the tokens
    tokens = tokenizer.encode(string, add_special_tokens=True) 
    # Truncate the tokens to a maximum length
    truncated_tokens = tokens[:max_tokens]
    # transform the tokens back to text
    truncated_text = tokenizer.decode(truncated_tokens)
    return truncated_text
```

This code leverages the Hugging Face Transformers library to tokenize text using the `LlamaTokenizerFast` model. The tokenizer is initialized from the pre-trained `hf-internal-testing/llama-tokenizer` model, and its `model_max_length` attribute is set to `sys.maxsize` to handle extremely large inputs without length constraints.

The `truncate_string` function takes a string and a maximum token count as inputs. It tokenizes the input string, truncates the tokenized sequence to the specified maximum length, and then decodes the truncated tokens back into a string. This function effectively shortens the text to a specified token limit while preserving its readable format, useful for tasks requiring length constraints on input text.

We will truncate our chunks to 1000 tokens, to leave plenty of space for the rest of the prompt and the answer.

```python
# transform docs into a string array using the "paylod" key
docs_as_one_string = "\n=========\n".join([doc["text"] for doc in docs])
docs_truncated = truncate_string(docs_as_one_string, 1000)
```

In our case, the prompt will include the retrieved top chunks, the question posed by the user, and the custom instructions.

```python
prompt = f"""\
    Respond to PRECISELY to this question: "{question}.",  USING ONLY the following information and IGNORING ANY PREVIOUS KNOWLEDGE.
    =====
    Sources: {docs_truncated}
    =====
    Answer (Three paragraphs, maximum 50 words each, 90% spartan):
    """
```

### Call the Generative AI Service LLM

First, log in to Google Cloud using the right credentials.

```bash
pip install --upgrade google-cloud-aiplatform
gcloud auth application-default login
```

```python
import vertexai
from vertexai.generative_models import GenerativeModel, SafetySetting, Part
```

Here are the general parameters we want for our LLM calls. Feel free to adjust them as needed.

```python
generation_config = {
    "max_output_tokens": 8192,
    "temperature": 1,
    "top_p": 0.95,
}

safety_settings = [
    SafetySetting(
        category=SafetySetting.HarmCategory.HARM_CATEGORY_HATE_SPEECH,
        threshold=SafetySetting.HarmBlockThreshold.OFF
    ),
    SafetySetting(
        category=SafetySetting.HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT,
        threshold=SafetySetting.HarmBlockThreshold.OFF
    ),
    SafetySetting(
        category=SafetySetting.HarmCategory.HARM_CATEGORY_SEXUALLY_EXPLICIT,
        threshold=SafetySetting.HarmBlockThreshold.OFF
    ),
    SafetySetting(
        category=SafetySetting.HarmCategory.HARM_CATEGORY_HARASSMENT,
        threshold=SafetySetting.HarmBlockThreshold.OFF
    ),
]
```

When we initialize the model, an important part is the system prompt, as you can see below. Strongly instructing it to ignore previous knowledge (acquired during the initial training of the model) is very important if we want it to first look at our text chunks.

```python
vertexai.init(project="<Your Google Cloud Project Name>", location="<Your Google Cloud Region>")
model = GenerativeModel(
    "gemini-1.5-flash-002",
    system_instruction=["""
    You are a helpful assistant named Oracle chatbot. 
    USE ONLY the sources below and ABSOLUTELY IGNORE any previous knowledge.
    Use Markdown if appropriate.
    Assume the customer is highly technical.     
    Include code snippets and commands where necessary.
    NEVER mention the sources, always respond as if you have that knowledge yourself. Do NOT provide warnings or disclaimers.          
    """]
)
chat = model.start_chat()
```

And now, let's call the model with our prompt.

```python
r = chat.send_message(
    prompt,
    generation_config=generation_config,
    safety_settings=safety_settings
)

r
candidates {
    content {
    role: "model"
    parts {
        text: "Always Free services are a component of the Oracle Cloud Free Tier, offering unlimited access to specific services.  These include AMD-based and Arm-based compute instances, block and object storage, and archive storage.  Further Always Free services may be added automatically.\n\n\nLimitations apply to Always Free services.  Unlike the Free Trial's $300 credit,  Always Free services have no time limit. However, Always Free users don't receive SLAs or Oracle Support.\n\n\nCommunity forums offer support for all users.  To access Oracle Support and SLAs, upgrade to a paid account after consuming Free Trial credits or when the trial expires.\n"
    }
    }
    finish_reason: STOP
    avg_logprobs: -0.3260646877866803
}
usage_metadata {
    prompt_token_count: 1042
    candidates_token_count: 132
    total_token_count: 1174
}
model_version: "gemini-1.5-flash-002"
```

As you can see, we have a nice answer, based on our small knowledge base, coming from the LLM.

```python
pprint.pp(r.candidates[0].content.parts[0].text, width=150)
('Always Free services are a component of the Oracle Cloud Free Tier, offering unlimited access to specific services.  These include AMD-based and '
    'Arm-based compute instances, block and object storage, and archive storage.  Further Always Free services may be added automatically.\n'
    '\n'
    '\n'
    "Limitations apply to Always Free services.  Unlike the Free Trial's $300 credit,  Always Free services have no time limit. However, Always Free "
    "users don't receive SLAs or Oracle Support.\n"
    '\n'
    '\n'
    'Community forums offer support for all users.  To access Oracle Support and SLAs, upgrade to a paid account after consuming Free Trial credits or '
    'when the trial expires.\n')
```

You may proceed to the next step [Add Streamlit Frontend App for Oracle Autonomous Database on GCP](README_FRONTEND.md)