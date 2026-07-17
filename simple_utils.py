# simple_utils.py

def reverse_string(text):
    return text[::-1]


def count_words(sentence):
    return len(sentence.split())


def celsius_to_fahrenheit(celsius):
    return (celsius * 9/5) + 32


def average(numbers):
    return sum(numbers) / len(numbers)


def parse_score(raw):
    name, score = raw.split(":")
    return {"name": name, "score": int(score)}
