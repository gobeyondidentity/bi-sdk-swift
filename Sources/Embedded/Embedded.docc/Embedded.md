# ``BeyondIdentityEmbedded``

Passwordless Authentication for Swift

## Overview

Beyond Identity helps developers deploy the strongest authentication primitives on the planet, eliminating shared secrets for sign-up, login, and recovery. Customers never have to type a password, enter a code, click a push notification, or pick up a second device.

The BeyondIdentityEmbedded SDK contains the models and functions for developers to implement Passwordless Authentication using industry-standard protocols OIDC/OAuth2.0 and "Universal Passkeys".

Passkeys are based on public-private key pairs that are cryptographically linked to the user and can be centrally managed using the Beyond Identity APIs.

## Topics

### Initialization
Before using any functionality you must initalize the SDK with `Embedded.initalize`

- ``Embedded/initialize(allowedDomains:biometricAskPrompt:logger:callback:)``

### Essential APIs
After initalization, the following can be accessed using the `Embedded.shared` singleton
- ``Embedded``
- ``CoreEmbedded/authenticate(url:id:callback:)``
- ``CoreEmbedded/bindPasskey(url:callback:)``
- ``CoreEmbedded/deletePasskey(for:callback:)``
- ``CoreEmbedded/getPasskey(callback:)``
- ``CoreEmbedded/isAuthenticateUrl(_:)``
- ``CoreEmbedded/isBindPasskeyUrl(_:)``
