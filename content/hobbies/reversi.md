---
title: "Reversi"
---
## Overview {#overview}
A full-stack Reversi (Othello) project built from scratch—from a high-performance Rust game engine to a web app and AlphaZero-style AI training pipeline.
The game engine uses bitboard representation for fast move generation and search. It is published as both a Rust crate and a Python package, and powers the web application and various AI experiments.

**Live Demo**: [Play Reversi in your browser](https://reversi.neodymium6.net)

![Reversi web app gameplay screenshot](/images/hobbies/reversi/reversi-web-ui.webp)

## Architecture {#architecture}
The project is organized into six repositories, layered by responsibility:

| Layer | Repository | Description |
|-------|-----------|-------------|
| Game Engine | [rust_reversi_core](https://github.com/neodymium6/rust_reversi_core) | Bitboard engine, alpha-beta search, arena system. [[crates.io]](https://crates.io/crates/rust_reversi_core) |
| Python Bindings | [rust_reversi](https://github.com/neodymium6/rust_reversi) | PyO3/maturin bindings exposing board, search, and arena to Python. [[PyPI]](https://pypi.org/project/rust-reversi/) |
| Backend | [reversi-backend](https://github.com/neodymium6/reversi-backend) | FastAPI REST API with game session management, AI opponents, and PostgreSQL stats. |
| Frontend | [reversi-frontend](https://github.com/neodymium6/reversi-frontend) | React 19 + TypeScript + Tailwind CSS v4 web UI. |
| AI Experiments | [reversi_ai](https://github.com/neodymium6/reversi_ai) | Genetic algorithms, supervised learning, RL, and knowledge distillation. |
| AlphaZero | [reversi-zero](https://github.com/neodymium6/reversi-zero) | Self-play MCTS in Rust + PyTorch training loop. |

## Game Engine {#game-engine}
The core engine is written in Rust with a focus on performance:
- **Bitboard representation**: The entire 8×8 board state fits in two `u64` values, enabling fast bitwise move generation and flipping.
- **Alpha-beta search**: Iterative deepening with timeout control and pluggable evaluation functions (piece count, positional matrix, custom).
- **MCTS**: Monte Carlo Tree Search with UCB1 for playout-based decision making.
- **Arena**: Local and TCP/IP network match systems with automatic statistics collection.

## Web Application {#web-app}
A full-stack web app for playing Reversi against AI opponents in the browser.

- **Frontend**: React 19, TypeScript, Vite, Tailwind CSS v4. Responsive design with legal move indicators and real-time score tracking.
- **Backend**: FastAPI serving a REST API. Manages game sessions in memory, spawns AI player processes, and records AI statistics (win rate, average score) in PostgreSQL.
- **AI opponents**: Random, alpha-beta with piece evaluation (depth 3 and 5). Extensible to custom players.
- **Deployment**: Dockerized frontend and backend, running on my [homelab](/hobbies/homelab/) via Cloudflare Tunnel.

## AI & Training {#ai-training}
Multiple approaches to building stronger Reversi players:
- **Genetic algorithms**: Evolving evaluation function weights, implemented in both Python and Rust.
- **Supervised learning**: Training neural networks on game records.
- **Reinforcement learning**: Policy optimization through self-play.
- **Knowledge distillation**: Compressing strong models into smaller, faster ones.
- **AlphaZero pipeline** (reversi-zero): Rust handles parallel self-play with batched MCTS inference, Python/PyTorch trains policy+value networks, and TorchScript bridges the two. Each iteration generates games, trains the network, and evaluates against baseline opponents.

## Tech Stack {#tech-stack}
- **Game Engine**: Rust, bitboard, alpha-beta, MCTS
- **Python Bindings**: PyO3, maturin
- **Frontend**: React 19, TypeScript, Vite, Tailwind CSS v4
- **Backend**: FastAPI, PostgreSQL, SQLAlchemy, Alembic
- **AI/ML**: PyTorch, TorchScript, NumPy
- **Infrastructure**: Docker, GitHub Actions, Cloudflare Tunnel
