# RTX / Rentokil WireMock Sandbox

Ready-to-deploy WireMock project for Kore.ai integration testing.

It exposes the three Phase 1 mock APIs from the RTX TDD and supports deterministic conditional responses based on request values.

## APIs

1. `POST /api/gateway?api=phone_search`
2. `POST /customer/account-details`
3. `PUT /V2/MakeOneTimePayment`

The mappings are intentionally deterministic so you can test Kore.ai flows such as:

- ANI / phone search: no match, single candidate, multiple candidates
- Candidate account lookup: different responses for different account numbers
- Invoice lookup: different responses for different invoice numbers
- No payable invoices
- Payment success / failure / PestPac posting failure / timeout

## Deploy to Render

Push this directory to GitHub, then create a new **Web Service** in Render and select the repository.

Render settings:

- Runtime: Docker
- Dockerfile: `./Dockerfile`
- Port: `8080`
- Plan: Free

`render.yaml` is also included for Blueprint deployment.

Your endpoint will look like:

`https://<your-service-name>.onrender.com`

## Local run

```bash
docker build -t rtx-wiremock .
docker run --rm -p 8080:8080 rtx-wiremock
```

Then open:

`http://localhost:8080/__admin/mappings`

## Test data

### phone_search

POST body examples:

```json
{"phone":"1111111111","tenant-id":"test","limit":5}
```

Returns one PestPac candidate: `12345`.

```json
{"phone":"2222222222","tenant-id":"test","limit":5}
```

Returns two PestPac candidates: `12345`, `67890`.

```json
{"phone":"3333333333","tenant-id":"test","limit":5}
```

Returns zero candidates.

### account-details by account number

```json
{"sourceSystem":"PestPac","accountNumber":"12345"}
```

Returns customer A, three invoices, and one non-payable invoice.

```json
{"sourceSystem":"PestPac","accountNumber":"67890"}
```

Returns customer B, two invoices.

```json
{"sourceSystem":"PestPac","accountNumber":"99999"}
```

Returns a valid customer with zero payable invoices.

### account-details by invoice number

```json
{"sourceSystem":"PestPac","invoiceNumber":"INV111111"}
```

Returns account `12345` and its invoice set.

```json
{"sourceSystem":"PestPac","invoiceNumber":"INV333333"}
```

Returns account `67890` and its invoice set.

### Payment

The mock branches on `CustomerIdentifier`:

- `TEST_SUCCESS` → `Success` + PestPac posting `Success`
- `TEST_FAILURE` → `Failure` + `Insufficient Funds`
- `TEST_POSTING_FAILURE` → `Success` + PestPac posting `Failure`
- `TEST_TIMEOUT` → delayed response to simulate timeout behavior
- anything else → generic success

## Conditional matching

The project uses WireMock JSONPath body matchers. Example:

```json
"bodyPatterns": [
  {
    "matchesJsonPath": "$[?(@.accountNumber == '12345')]"
  }
]
```

The same endpoint can therefore return a different response for each account/invoice value.

## Kore.ai configuration

Use your Render service URL as the API host. The path remains unchanged:

```text
POST https://<service>.onrender.com/api/gateway?api=phone_search
POST https://<service>.onrender.com/customer/account-details
PUT  https://<service>.onrender.com/V2/MakeOneTimePayment
```

For the production TDD contract, your Kore tool layer still owns the required headers/authentication. This mock intentionally does not require Okta/Kong credentials.
