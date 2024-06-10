from locust import HttpUser, task, between
import locust
import json
'''
File created by Rishabh - 5/6/24
'''
class User(HttpUser):
    wait_time = between(1, 5)  # Simulate user wait time between requests (in seconds)

    @task
    def dynamic_tasks(self):
        response = self.client.get("/routes")
        routes = json.loads(response.text)
        for route in routes:
            url = route['url']
            if "GET" in route['methods']:
                self.client.get(url)
            elif "POST" in route['methods']:
                # Assuming the POST endpoints can handle empty data for testing purposes
                self.client.post(url, json={})

    def on_start(self):
        self.login()  # Simulate login before other tasks

    def login(self):
        # Replace with your actual login endpoint and credentials
        self.client.post("/login", json={"username": "admin1", "password": "admin1"})

# Configure the number of virtual users and spawn rate
locust.user = User
