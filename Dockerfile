FROM python:3.8

# Set the working directory in the container

WORKDIR /app

EXPOSE 5000/tcp

# Copy the dependencies file to the working directory

COPY requirement.txt .

# Install any dependencies

RUN pip install -r requirement.txt

# Copy the content of the local src directory to the working directory

COPY . .

# Specify the command to run on container start

CMD [ "python", "./backend.py" ]



#ENV PYTHONPATH "${PYTHONPATH}:/basedSecurity/"

