import nlpcloud

client = nlpcloud.Client("finetuned-llama-3-70b", "1fdc61c8f4c5df97038163bc6aa49c6dd55d3a02", gpu=True)


def ner(text):
    ner_response = client.entities(text, searched_entity="programming languages")
    return ner_response
