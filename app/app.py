from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
   return "Hello from Terraform + Ansible + GitHub Actions!"

app.run(host="0.0.0.0", port=5000 , debug=True)
