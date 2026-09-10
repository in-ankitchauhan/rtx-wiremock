#!/usr/bin/env bash
set -euo pipefail
BASE_URL="${1:-http://localhost:8080}"

echo "== phone search: single =="
curl -sS -X POST "$BASE_URL/api/gateway?api=phone_search" -H 'Content-Type: application/json' -d '{"phone":"1111111111","tenant-id":"test","limit":5}'
echo -e "\n"

echo "== phone search: multiple =="
curl -sS -X POST "$BASE_URL/api/gateway?api=phone_search" -H 'Content-Type: application/json' -d '{"phone":"2222222222","tenant-id":"test","limit":5}'
echo -e "\n"

echo "== account 12345 =="
curl -sS -X POST "$BASE_URL/customer/account-details" -H 'Content-Type: application/json' -H 'X-Correlation-Id: test-123' -d '{"sourceSystem":"PestPac","accountNumber":"12345"}'
echo -e "\n"

echo "== account 67890 =="
curl -sS -X POST "$BASE_URL/customer/account-details" -H 'Content-Type: application/json' -H 'X-Correlation-Id: test-678' -d '{"sourceSystem":"PestPac","accountNumber":"67890"}'
echo -e "\n"

echo "== invoice INV111111 =="
curl -sS -X POST "$BASE_URL/customer/account-details" -H 'Content-Type: application/json' -H 'X-Correlation-Id: test-inv' -d '{"sourceSystem":"PestPac","invoiceNumber":"INV111111"}'
echo -e "\n"

echo "== payment success =="
curl -sS -X PUT "$BASE_URL/V2/MakeOneTimePayment" -H 'Content-Type: application/json' -d '{"PaymentPlatform":"Rentokil","PaymentRequestNumber":"REQ-1","CustomerIdentifier":"TEST_SUCCESS","TotalPaymentAmount":250.0,"Invoices":[{"InvoiceNumber":"INV111111","SplitApplyAmount":250.0}],"PaymentMethod":{"PaymentType":"CARD","PaymentSubType":"VISA","CreditCardNumber":"4111111111111111","SecurityCode":"123","ExpiryDateMMYY":"1299"},"BillingAddress":{"Street":"742 Evergreen Terrace","City":"Dallas","State":"TX","PostalCode":"75201"}}'
echo -e "\n"
