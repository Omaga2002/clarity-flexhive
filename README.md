# FlexHive
A decentralized marketplace for flexible gigs and short-term work opportunities built on Stacks.

## Features
- Post gigs with detailed requirements and compensation
- Apply for gigs as a worker
- Escrow system for secure payments
- Rating system for both employers and workers
- Dispute resolution mechanism

## Contract Functions
- `post-gig`: Post a new gig with details and deposit funds
- `apply-for-gig`: Apply as a worker for a posted gig
- `accept-application`: Accept a worker's application
- `complete-work`: Mark work as completed (by worker)
- `approve-work`: Approve completed work and release payment (by employer)
- `submit-rating`: Submit rating for completed gig
- `raise-dispute`: Raise dispute for resolution

## Testing
Run tests using Clarinet:
```bash
clarinet test
```
