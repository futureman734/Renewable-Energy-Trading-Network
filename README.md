# Renewable Energy Trading Network

A decentralized platform for renewable energy trading, verification, and carbon offset management built on the Stacks blockchain using Clarity smart contracts.

## Overview

The Renewable Energy Trading Network consists of five interconnected smart contracts that enable:

- **Energy Production Verification**: Validates and records renewable energy generation
- **Grid Contribution Tracking**: Monitors energy fed into power grids
- **Peer-to-Peer Energy Trading**: Facilitates direct energy sales between users
- **Carbon Offset Calculations**: Computes environmental impact credits
- **Energy Storage Management**: Handles battery and storage systems

## Smart Contracts

### 1. Energy Production Verification (`energy-production.clar`)
- Registers energy producers and their renewable energy sources
- Validates energy production data with timestamps
- Maintains production history and verification status
- Supports solar, wind, hydro, and other renewable sources

### 2. Grid Contribution Contract (`grid-contribution.clar`)
- Tracks energy fed into the power grid
- Records contribution amounts and timestamps
- Calculates grid contribution rewards
- Manages grid connection status for producers

### 3. Peer-to-Peer Trading Contract (`p2p-trading.clar`)
- Creates energy trading offers between users
- Matches buyers and sellers automatically
- Handles energy transfer transactions
- Manages trading fees and escrow

### 4. Carbon Offset Calculation Contract (`carbon-offset.clar`)
- Calculates carbon credits based on renewable energy production
- Tracks carbon offset balances for users
- Enables carbon credit trading
- Maintains environmental impact records

### 5. Energy Storage Management Contract (`energy-storage.clar`)
- Manages battery and storage system registrations
- Tracks energy storage and discharge cycles
- Optimizes storage allocation across the network
- Handles storage capacity and efficiency metrics

## Key Features

- **Decentralized Verification**: All energy production is verified on-chain
- **Transparent Trading**: Peer-to-peer energy trading with full transparency
- **Carbon Credit System**: Automatic carbon offset calculation and trading
- **Storage Optimization**: Intelligent energy storage management
- **Grid Integration**: Seamless integration with existing power grids

## Data Types

- **Energy Sources**: Solar, Wind, Hydro, Geothermal, Biomass
- **Energy Units**: Measured in kilowatt-hours (kWh)
- **Carbon Credits**: Calculated based on CO2 equivalent reduction
- **Storage Types**: Battery, Pumped Hydro, Compressed Air

## Error Codes

- `u100`: Unauthorized access
- `u101`: Invalid energy source
- `u102`: Invalid production amount
- `u103`: Producer not registered
- `u104`: Insufficient balance
- `u105`: Invalid trading offer
- `u106`: Storage system not found
- `u107`: Invalid storage capacity
- `u108`: Grid connection required

## Getting Started

1. Deploy all five smart contracts to the Stacks blockchain
2. Register as an energy producer with verified renewable sources
3. Start recording energy production data
4. Participate in peer-to-peer trading or contribute to the grid
5. Earn carbon credits and manage energy storage

## Testing

Run the test suite using Vitest:

\`\`\`bash
npm test
\`\`\`

## License

MIT License - see LICENSE file for details
