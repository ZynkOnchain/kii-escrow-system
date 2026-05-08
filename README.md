# KiiEscrow

![Solidity](https://img.shields.io/badge/Solidity-0.8.20-blue)
![Network](https://img.shields.io/badge/Network-Kii_Testnet-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

A decentralized escrow smart contract deployed on Kii Chain testnet.

---

## Features

- Buyer/Seller escrow workflow
- Arbiter-based dispute resolution
- State-managed transaction lifecycle
- Event emissions for transparency
- Secure escrow fund handling

---

## Workflow

1. Buyer creates a deal
2. Buyer deposits funds into escrow
3. Seller confirms delivery
4. Contract releases funds securely
5. Arbiter can resolve disputes if needed

---

## Contract States

- `AWAITING_PAYMENT`
- `AWAITING_DELIVERY`
- `COMPLETE`
- `DISPUTED`
- `REFUNDED`

---

## Tech Stack

- Solidity ^0.8.20
- Remix IDE
- Kii Chain Testnet

---

## Contract Address

```text
0x54559aB59733233c322B277A38eb1F563053d0a2
```

---

## Future Improvements

- Platform fee mechanism
- Deadline-based auto refunds
- Multi-signature arbitration
- Frontend integration
- Escrow analytics dashboard

---

## License

MIT
