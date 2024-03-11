#using standard python slim base image
FROM python:3.11

#setting up the working directory in the container
WORKDIR /app

#installing poetry as it manages the dependencies
RUN pip install poetry

#copying content over from host to container directory 
COPY . /app

#running poetry to install dependencies from lock file
RUN poetry install --no-dev --no-interaction

EXPOSE 8000

#defining an entry point for uvicorn
CMD ["poetry", "run", "uvicorn", "src.api:app", "--host", "0.0.0.0", "--port", "8000"]