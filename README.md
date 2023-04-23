# Scoby Analytics: VCL Snippet

This VCL snippet is designed to help Fastly customers integrate with Scoby Analytics.

[scoby](https://www.scoby.io) is an ethical analytics tool that helps you protect your visitors' privacy without sacrificing meaningful metrics. The data is sourced directly from your web server, no cookies are used and no GDPR, ePrivacy and Schrems II consent is required.

Start your free trial today [https://app.scoby.io/register](https://app.scoby.io/register)

#### Did you know?
scoby is free for non-profit projects.
[Claim your free account now](mailto:hello@scoby.io?subject=giving%20back)

## Prerequisites
You need two values to instantiate your scoby analytics client: your API key and a salt.
The salt is used to anonymize your traffic before it is sent to our servers.
You can generate a cryptographically secure using the following command:

````shell
openssl rand -base64 32
````

- This VCL snippet requires the [digest](https://docs.fastly.com/en/guides/using-digests-in-vcl/) module to be included in the Fastly service configuration.


## Usage

To use this VCL snippet, you need to follow the instructions below:

1. Find your API key in your [workspace's settings](https://app.scoby.io) - don't have a workspace yet? Create one for free [here](https://app.scoby.io)
3. Replace the following variables in the code with your own values:

- `var.apiKey`: This should be replaced with your base64 encoded API key.
- `var.salt`: This should be replaced with a salt value.

4. Include this code in your Fastly service configuration to log request details for the specified workspace.