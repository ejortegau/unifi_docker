#!/usr/bin/env python
import json
import logging
import random
import string

import boto3

from dataclasses import dataclass, asdict

from botocore.exceptions import ClientError

MONGODB_SECRET_KEY = "unifi_controller_mongodb"

MONGODB_SECRET_USERNAME_KEY = "MONGODB_SECRET_KEY"
MONGODB_SECRET_USERNAME = "unifi"


@dataclass
class Credentials:
    username: str
    password: str


class CredentialsException(Exception):
    pass


class UnhandledCredentialsException(CredentialsException):
    pass


class InvalidSecret(CredentialsException):
    pass


class CredentialsNotFound(CredentialsException):
    pass


class CredentialCreationException(CredentialsException):
    pass


def create_mongodb_credentials() -> Credentials:
    password = ''.join(random.choices(string.ascii_lowercase + string.ascii_uppercase + string.digits, k=16))
    creds = Credentials(username=MONGODB_SECRET_USERNAME, password=password)

    json_creds = json.dumps(asdict(creds))

    session = boto3.Session(profile_name="cli-sso")
    secrets_manager = session.client("secretsmanager")

    try:
        secrets_manager.create_secret(Name=MONGODB_SECRET_KEY, SecretString=json_creds)
    except Exception as exc:
        raise CredentialCreationException from exc

    return creds


def get_mongodb_credentials():
    session = boto3.Session(profile_name="cli-sso")
    secrets_manager = session.client("secretsmanager")
    try:
        result = secrets_manager.get_secret_value(SecretId=MONGODB_SECRET_KEY)
    except ClientError as exc:
        if exc.response['Error']['Code'] in {"ResourceNotFoundException", "InvalidRequestException"}:
            raise CredentialsNotFound from exc

        logging.error("Failed to try to retrieve pre-existing Mongodb credentials")
        raise UnhandledCredentialsException from exc

    logging.info("Mongodb credentials found, reusing them")
    secret_str = result['SecretString']
    secret_dict = json.loads(secret_str)

    try:
        creds = Credentials(**secret_dict)
        return creds
    except TypeError as exc:
        logging.error("Unable to parse retrieved secret as type credentials. Keys in secret are %s, expected"
                      "keys are %s", list(secret_dict.keys()), list(Credentials("", "").__dict__.keys())
                      )
        raise InvalidSecret from exc


def ensure_mongodb_credentials() -> Credentials:
    try:
        return get_mongodb_credentials()
    except CredentialsNotFound:
        return create_mongodb_credentials()


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    logging.getLogger().setLevel(logging.INFO)
    creds = ensure_mongodb_credentials()

    logging.info("Credentials found")

    tpl = f"""db.getSiblingDB(\"unifi_db\").createUser({{user: \"{creds.username}\", pwd: \"{creds.password}\", roles: [{{role: \"dbOwner\", db: \"unifi_db\"}}]}});
db.getSiblingDB(\"unifi_db_stat\").createUser({{user: \"{creds.username}\", pwd: \"{creds.password}\", roles: [{{role: \"dbOwner\", db: \"unifi_db_stat\"}}]}});
"""

    with open("./init-mongo.js", "w") as fd:
        fd.write(tpl)


