# Use an official lightweight Python image.
# https://hub.docker.com/_/python
FROM python:3.7-slim

# Install production dependencies.
RUN pip install Flask

# Copy local code to the container image.
WORKDIR /app
COPY . .

CMD python main.py
