from setuptools import setup


with open("README.md") as f:
    readme = f.read()

requirements = ['websockets>=8.1']

keywords = (["notuno", "uno", "game", "cli", "websockets", "multiplayer"])

setup(
    name="notuno",
    version="0.1.0",
    packages=['notuno'],
    url="https://github.com/redraskal/NotUno",
    license="MIT",
    author="Ben Ryan",
    author_email="ben@ryben.dev",
    description="Play NotUno online with friends!",
    long_description=readme,
    python_requires=">=3.6",
    entry_points={"console_scripts": ["notuno=notuno.__main__:main"]},
    keywords=keywords
)