import streamlit as st
import oracledb
import json
import array
from sentence_transformers import SentenceTransformer
from transformers import LlamaTokenizerFast
import vertexai
from vertexai.generative_models import GenerativeModel, SafetySetting, Part
import time

with open('config.json') as f:
    config = json.load(f)

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

encoder = SentenceTransformer(config['models']['sentence_transformer'])
tokenizer = LlamaTokenizerFast.from_pretrained(config['models']['llama_tokenizer'])

vertexai.init(project=config['vertex_ai']['project_id'], location=config['vertex_ai']['location'])
model = GenerativeModel(
    config['models']['generative_model'],
    system_instruction=config['system_instruction']
)

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

def generate_response(prompt):
    chat = model.start_chat()
    r = chat.send_message(
        prompt,
        generation_config=config['generation_config'],
        safety_settings=[SafetySetting(**setting) for setting in config['safety_settings']]
    )
    return r.candidates[0].content.parts[0].text

def truncate_string(string, max_tokens):
    tokens = tokenizer.encode(string, add_special_tokens=True) 
    truncated_tokens = tokens[:max_tokens]
    truncated_text = tokenizer.decode(truncated_tokens)
    return truncated_text

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
    display_references(chunks)  