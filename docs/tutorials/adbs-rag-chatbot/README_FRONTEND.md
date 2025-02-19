# Add Streamlit Frontend App for Oracle Autonomous Database on Google Cloud Platform

Next we'll explore how to build a Streamlit frontend app that connects to an Oracle Autonomous Database on Google Cloud Platform (GCP). We'll cover the prerequisites, installation steps, and provide a sample code snippet to get you started.

### Streamlit Frontend App
This Streamlit app connects to an Oracle database, retrieves FAQs, and generates responses using a generative model.

### Import Libraries

```python
import streamlit as st
import oracledb
import json
import array
from sentence_transformers import SentenceTransformer
from transformers import LlamaTokenizerFast
import vertexai
from vertexai.generative_models import GenerativeModel, SafetySetting, Part
import time
```

### Load Configuration
Load the configuration file (config.json) that contains database credentials, model settings, and other parameters.

```python
with open('config.json') as f:
    config = json.load(f)
```

### Establish Database Connection

Connect to the Oracle database using the oracledb library.

```python
try:
    connection = oracledb.connect(
        config_dir=config['oracle']['wallet_directory'],
        user=config['oracle']['username'],
        password=config['oracle']['password'],
        dsn=config['oracle']['dsn'],
        wallet_location=config['oracle']['wallet_directory'],
        wallet_password=config['oracle']['wallet_password']
    )
    # print("Connected to the database!")
except Exception as e:
    print(f"Failed to connect to the database: {str(e)}")
```

### Initialize Models

Initialize the sentence transformer and LLaMA tokenizer models.

```python
encoder = SentenceTransformer(config['models']['sentence_transformer'])
tokenizer = LlamaTokenizerFast.from_pretrained(config['models']['llama_tokenizer'])
```

### Initialize Vertex AI Model

Initialize the Vertex AI generative model.

```python
vertexai.init(project=config['vertex_ai']['project_id'], location=config['vertex_ai']['location'])
model = GenerativeModel(
    config['models']['generative_model'],
    system_instruction=config['system_instruction']
)
```

### Load FAQs

Retrieve FAQs from the database.

```python
def load_faqs():
    with connection.cursor() as cursor:
        query = "SELECT payload FROM faqs"
        cursor.execute(query)
        rows = cursor.fetchall()
        faqs = []
        for row in rows:
            faq = row[0]
            faqs.append(faq)
        return faqs
```

### Get Relevant Chunks

Retrieve relevant chunks from the database based on the user's question.

```python
def get_relevant_chunks(question):
    with connection.cursor() as cursor:
        sql = """SELECT payload, vector_distance(vector, :vector, COSINE) AS score
                 FROM faqs ORDER BY score FETCH FIRST 3 ROWS ONLY"""
        embedding = list(encoder.encode(question))
        vector = array.array("f", embedding)
        cursor.execute(sql, vector=vector)
        rows = cursor.fetchall()
        chunks = []
        for row in rows:
            chunk = row[0]
            chunks.append(chunk)
        return chunks
```

### Generate Response

Generate a response using the Vertex AI model.

```python
def generate_response(prompt):
    chat = model.start_chat()
    r = chat.send_message(
        prompt,
        generation_config=config['generation_config'],
        safety_settings=[SafetySetting(**setting) for setting in config['safety_settings']]
    )
    return r.candidates[0].content.parts[0].text
```

### Truncate String

Truncate a string to a specified length.

```python
def truncate_string(string, max_tokens):
    tokens = tokenizer.encode(string, add_special_tokens=True) 
    truncated_tokens = tokens[:max_tokens]
    truncated_text = tokenizer.decode(truncated_tokens)
    return truncated_text
```

### Display References

Display references in a user-friendly format.

```python
def display_references(chunks):
    """Displays references in a user-friendly format."""
    
    if not chunks:  
        st.info("No relevant information found.")
        return
    
    st.subheader("References")
    
    for i, chunk in enumerate(chunks):
        with st.expander(f"Reference {i+1}"):
            st.write(f"**Source:** FAQ")
            st.write(chunk)
            st.code(chunk, language=None, line_numbers=False) 
```

### Main App

The main app logic.

```python
st.title("Frequently asked questions")
question = st.text_input("Enter your question:")

if st.button("Ask"):
    start_time = time.time()
    faqs = load_faqs()
    chunks = get_relevant_chunks(question)
    truncated_chunks = [truncate_string(str(chunk), 1000) for chunk in chunks]
    prompt = f"""Respond to PRECISELY to this question: "{question}".\n\nSources:\n{truncated_chunks}\n\nAnswer (Three paragraphs, maximum 50 words each, 90% spartan):"""
    response = generate_response(prompt)
    end_time = time.time()
    latency = end_time - start_time
    print(f"Rendering time: {latency:.2f} seconds")
    st.write("Answer:")
    st.write(response)
    display_references(chunks)"
```

## Conclusion

In conclusion, deploying an Autonomous Database on GCP involves several steps, including creating a VPC, subnets, firewall rules, a bastion host or Windows VM, and configuring instaclient and sqlcl. By automating these steps using a Bash script, we can streamline the process and reduce the risk of human error. The script provides a flexible and modular approach to deploying an Autonomous Database on GCP, allowing us to customize and extend it as needed.