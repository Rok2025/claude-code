# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Node.js + Express + TypeScript demo project for testing Claude Code functionality.

## Common Commands

### Development
```bash
npm install        # Install dependencies
npm run dev        # Start development server with nodemon (watches for changes)
npm start          # Start production server
```

### Build & Quality
```bash
npm run build      # Compile TypeScript to JavaScript
npm test           # Run Jest tests
npm run lint       # Run ESLint code checks
```

## Technology Stack

- **Runtime**: Node.js
- **Framework**: Express.js (REST API server)
- **Language**: TypeScript
- **Testing**: Jest
- **Dev Tools**: nodemon (auto-reload), ESLint (linting)

## Project Structure

```
src/
├── index.ts       # Main Express server entry point (port 3000)
├── routes/        # API route handlers (empty, for future use)
└── utils/         # Utility functions (empty, for future use)

tests/             # Jest test files
```

## Architecture Notes

- Entry point: `src/index.ts` - simple Express server on port 3000
- Single root endpoint: `GET /` returns JSON message
- TypeScript source in `src/`, compiles to JavaScript via `tsc`
- Development uses `nodemon` to watch `.js` files (note: currently watches compiled output, not TypeScript source)
