# Add Streamlit Frontend App for Oracle Autonomous Database on Google Cloud Platform

Next we'll explore how to build a Streamlit frontend app that connects to an Oracle Autonomous Database on Google Cloud Platform (GCP). We'll cover the prerequisites, installation steps, and provide a sample code snippet to get you started.

### Streamlit Frontend App
This Streamlit app connects to an Oracle database, retrieves FAQs, and generates responses using a generative model.

**TLDR:** With this app, you'll be able to:

- Connect to your Oracle database with ease
- Retrieve FAQs and relevant information with precision
- Generate responses using advanced generative models
- Provide users with accurate and informative answers to their queries

## Run the app

- Clone the repo
- Navigate to the `tutorial` directory: `cd docs/tutorials/adbs-rag-chatbot`
- Update copy config json and update it with your config parameters: `cp app/config.json.txt app/config.json`
  
```json
{
    "oracle": {
        "username": "",
        "password": "",
        "dsn": "",
        "wallet_directory": "",
        "wallet_password": ""
    },
    "vertex_ai": {
        "project_id": "",
        "location": ""
    },
    "models": {
        "sentence_transformer": "all-MiniLM-L12-v2",
        "llama_tokenizer": "hf-internal-testing/llama-tokenizer",
        "generative_model": "gemini-1.5-flash-002"
    },
    "system_instruction": [
        "You are a helpful assistant named Oracle chatbot.",
    ],
    "generation_config": {
        "max_output_tokens": 8192,
        "temperature": 1,
        "top_p": 0.95
    },
    "safety_settings": [
        {
            "category": "HARM_CATEGORY_HATE_SPEECH",
            "threshold": "OFF"
        },
        {
            "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
            "threshold": "OFF"
        },
        {
            "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
            "threshold": "OFF"
        },
        {
            "category": "HARM_CATEGORY_HARASSMENT",
            "threshold": "OFF"
        }
    ]
}
```

- Create a virtual environment: `python3 -m venv venv`
- Activate the environment: `. ./venv/bin/activate`
- Install dependencies: `pip3 install -r requirements.txt`
- Run the script: `streamlit run main.py`

## Code walkthrough

### Import Libraries

```python
# Import necessary libraries for the application
import streamlit as st  # For building the web interface
import oracledb  # For connecting to the Oracle database
import json  # For loading configuration files
import array  # For converting data types
from sentence_transformers import SentenceTransformer  # For encoding sentences
from transformers import LlamaTokenizerFast  # For tokenizing text
import vertexai  # For interacting with Vertex AI models
from vertexai.generative_models import GenerativeModel, SafetySetting, Part  # For generating text
import time  # For measuring execution time
```

### Load Configuration
Load the configuration file (config.json) that contains database credentials, model settings, and other parameters.

```python
# Open the configuration file and load its contents
with open('config.json') as f:
    # Parse the JSON content into a Python dictionary
    config = json.load(f)
```

### Establish Database Connection

Connect to the Oracle database using the oracledb library.

```python
# Attempt to establish a connection to the Oracle database
try:
    # Create a connection object with the required parameters
    connection = oracledb.connect(
        config_dir=config['oracle']['wallet_directory'],  # Directory containing the wallet file
        user=config['oracle']['username'],  # Username for authentication
        password=config['oracle']['password'],  # Password for authentication
        dsn=config['oracle']['dsn'],  # Data source name
        wallet_location=config['oracle']['wallet_directory'],  # Location of the wallet file
        wallet_password=config['oracle']['wallet_password']  # Password for the wallet file
    )
    # Print a success message if the connection is established
    # print("Connected to the database!")
except Exception as e:
    # Handle any exceptions during connection establishment
    print(f"Failed to connect to the database: {str(e)}")
```

### Initialize Models

Initialize the sentence transformer and LLaMA tokenizer models.

```python
# Initialize the sentence transformer model
encoder = SentenceTransformer(config['models']['sentence_transformer'])

# Initialize the LLaMA tokenizer model
tokenizer = LlamaTokenizerFast.from_pretrained(config['models']['llama_tokenizer'])
```

### Initialize Vertex AI Model

Initialize the Vertex AI generative model.

```python
# Initialize the Vertex AI client
vertexai.init(project=config['vertex_ai']['project_id'], location=config['vertex_ai']['location'])

# Create a generative model instance
model = GenerativeModel(
    config['models']['generative_model'],  # Name of the generative model
    system_instruction=config['system_instruction']  # System instruction for the model
)
```

### Load FAQs

Retrieve FAQs from the database.

```python
# Define a function to load FAQs from the database
def load_faqs():
    # Create a cursor object to execute queries
    with connection.cursor() as cursor:
        # Define the query to retrieve FAQs
        query = "SELECT payload FROM faqs"

        # Execute the query
        cursor.execute(query)

        # Fetch all rows from the result set
        rows = cursor.fetchall()

        # Initialize an empty list to store FAQs
        faqs = []

        # Iterate over each row in the result set
        for row in rows:
            # Extract the FAQ from the row
            faq = row[0]

            # Append the FAQ to the list
            faqs.append(faq)

        # Return the list of FAQs
        return faqs
```

### Get Relevant Chunks

Retrieve relevant chunks from the database based on the user's question.

```python
# Define a function to retrieve relevant chunks
def get_relevant_chunks(question):
    # Create a cursor object to execute queries
    with connection.cursor() as cursor:
        # Define the query to retrieve relevant chunks
        sql = """SELECT payload, vector_distance(vector, :vector, COSINE) AS score
                 FROM faqs ORDER BY score FETCH FIRST 3 ROWS ONLY"""

        # Encode the user's question using the sentence transformer
        embedding = list(encoder.encode(question))

        # Convert the encoded question to an array
        vector = array.array("f", embedding)

        # Execute the query with the encoded question as a parameter
        cursor.execute(sql, vector=vector)

        # Fetch all rows from the result set
        rows = cursor.fetchall()

        # Initialize an empty list to store relevant chunks
        chunks = []

        # Iterate over each row in the result set
        for row in rows:
            # Extract the chunk from the row
            chunk = row[0]

            # Append the chunk to the list
            chunks.append(chunk)

        # Return the list of relevant chunks
        return chunks
```

### Generate Response

Generate a response using the Vertex AI model.

```python
# Define a function to generate a response
def generate_response(prompt):
    # Start a new chat session with the Vertex AI model
    chat = model.start_chat()

    # Send a message to the model with the given prompt
    r = chat.send_message(
        prompt,  # Prompt for the model
        generation_config=config['generation_config'],  # Generation configuration
        safety_settings=[SafetySetting(**setting) for setting in config['safety_settings']]  # Safety settings
    )

    # Return the generated response
    return r.candidates[0].content.parts[0].text
```

### Truncate String

Truncate a string to a specified length.

```python
# Define a function to truncate a string
def truncate_string(string, max_tokens):
    # Tokenize the input string
    tokens = tokenizer.encode(string, add_special_tokens=True)

    # Truncate the tokens to the specified length
    truncated_tokens = tokens[:max_tokens]

    # Decode the truncated tokens back to a string
    truncated_text = tokenizer.decode(truncated_tokens)

    # Return the truncated string
    return truncated_text
```

### Display References

Display references in a user-friendly format.

```python
# Define a function to display references
def display_references(chunks):
    # Check if there are any references
    if not chunks:
        # If not, display a message indicating no relevant information was found
        st.info("No relevant information found.")
        return

    # Display a subheading for the references section
    st.subheader("References")

    # Iterate over each reference
    for i, chunk in enumerate(chunks):
        # Create an expander component for the reference
        with st.expander(f"Reference {i+1}"):
            # Display the source of the reference
            st.write(f"**Source:** FAQ")

            # Display the reference itself
            st.write(chunk)

            # Display the reference as code
            st.code(chunk, language=None, line_numbers=False)
```

### Main App

The main app logic.

```python
# Set the title of the app
st.title("Frequently asked questions")

# Create a text input field for the user to enter their question
question = st.text_input("Enter your question:")

# Create a button to trigger the response generation
if st.button("Ask"):
    # Record the start time
    start_time = time.time()

    # Load FAQs from the database
    faqs = load_faqs()

    # Retrieve relevant chunks based on the user's question
    chunks = get_relevant_chunks(question)

    # Truncate the chunks to a specified length
    truncated_chunks = [truncate_string(str(chunk), 1000) for chunk in chunks]

    # Construct the prompt for the Vertex AI model
    prompt = f"""Respond to PRECISELY to this question: "{question}".\n\nSources:\n{truncated_chunks}\n\nAnswer (Three paragraphs, maximum 50 words each, 90% spartan):"""

    # Generate a response using the Vertex AI model
    response = generate_response(prompt)

    # Record the end time
    end_time = time.time()

    # Calculate the rendering time
    latency = end_time - start_time

    # Print the rendering time
    print(f"Rendering time: {latency:.2f} seconds")

    # Display the generated response
    st.write("Answer:")
    st.write(response)

    # Display the references
    display_references(chunks)
```

## Conclusion

In this comprehensive guide, we have successfully demonstrated how to deploy an Autonomous Database on Google Cloud Platform (GCP) and integrate it with a Streamlit frontend app. By leveraging the power of Oracle Autonomous Database and Vertex AI, we created a robust and scalable solution for retrieving FAQs and generating responses to user queries.

By following this step-by-step guide, developers and data scientists can replicate this solution to build their own custom applications, harnessing the capabilities of Oracle Autonomous Database and Vertex AI.
