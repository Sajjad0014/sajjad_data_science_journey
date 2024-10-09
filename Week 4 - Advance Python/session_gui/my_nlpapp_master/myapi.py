import nlpcloud


class API:
    def __init__(self):
        self.client = None

    def sentimen_analysis(self, text):
        self.client = nlpcloud.Client("distilbert-base-uncased-emotion",
                                      "1fdc61c8f4c5df97038163bc6aa49c6dd55d3a02", gpu=False)
        response = self.client.sentiment(text)
        return response

    def ner(self, text):
        self.client = nlpcloud.Client("finetuned-llama-3-70b", "1fdc61c8f4c5df97038163bc6aa49c6dd55d3a02", gpu=True)
        response = self.client.entities(text, searched_entity="programming languages")
        return response

    def heading_gen(self, text):
        self.client = nlpcloud.Client("t5-base-en-generate-headline", "1fdc61c8f4c5df97038163bc6aa49c6dd55d3a02", gpu=False)
        response = self.client.summarization(text)
        return response