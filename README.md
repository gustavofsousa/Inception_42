# Inception_42
🐳 This projects intents to create a docker image with services nginx, mariaDB and wordpress. By containerizing these components, you can easily set up and manage your development environment.

## Prerequisites

Before you begin, ensure that you have the following prerequisites installed:

    curl -fsSL https://get.docker.com/ | sh
    sudo usermod -aG docker <your_username>

Change <your_username> for the right value.

## Getting Started

To get started with this Dockerized stack, follow these steps:
Clone the repository to your local machine:

    git clone https://github.com/gustavofsousa/Inception_42.git
    cd Inception_42

Create a .env file with the necessary environment variables. You can use the provided .env.example file as a template and adjust the values as needed:

    cp src/.env.example src/.env
    vim src/.env

Write your credencials in .env file.

## Commands

To build and start the Docker, run:

    make all
This command will create and start the MariaDB, WordPress, and Nginx containers in the background.

To stop and remove the Docker containers, run:

    make down
    
To check status of the ruining containers, run:

    make status

To remove all containers, networks, and volumes created by Docker Compose, run:

    make clean

To see the logs, run:

    make logs <service_name>

Access your WordPress site in your web browser by visiting:
    
    https://localhost:443

 The warning SSL certificate is expected, just continue.

## Project Structure

The project directory is structured as follows:

+ ./src/docker-compose.yml: Docker Compose configuration file that defines the services, volumes, and networks for the stack.
+ ./src/requirements/: Directory containing Dockerfiles and other configuration files for each service (MariaDB, WordPress, Nginx).
+ /home/data_inception/: Directory containing data volumes for MariaDB and WordPress data persistence.

## Troubleshooting

If you encounter issues or errors, please open an Issue.


## Author
Gustavo F Sousa

- Github: [@gustavofsousa](https://github.com/gustavofsousa)
- Linkedin: [@gustavofsousa](https://www.linkedin.com/in/gustavofsousa/)

Give a ⭐ if this project has helped you!

Special thanks to the Docker community and the maintainers of MariaDB, WordPress, and Nginx.
