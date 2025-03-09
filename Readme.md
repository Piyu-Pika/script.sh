
# Project Generator Script

A shell script to quickly generate organized project structures for Node.js, Go, and Flutter applications.

## Table of Contents
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Project Structures](#project-structures)
- [Environment Variables](#environment-variables)
- [Development](#development)
- [Notes](#notes)

## Features

- Creates project structure for:
  - Node.js applications
  - Go applications
  - Flutter applications
- Generates essential configuration files:
  - Jest config
  - ESLint config
  - Gitignore
  - Environment files
- Includes sample test files
- Sets up organized directory structure
- Initializes Git repository

## Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd project-generator
```

2. Make the script executable:
```bash
chmod +x project-generator.sh
```

## Usage

Basic usage:
```bash
./project-generator.sh
```

Select the project type you want to generate:
- Node.js
- Go
- Flutter

Follow the interactive prompts to:
- Choose project name
- Select project type
- Generate project structure

## Project Structures

The script generates different project structures based on the selected language:

```plaintext
node-project/
├── src/                    
│   ├── api/                
│   │   ├── controllers/    
│   │   ├── middlewares/    
│   │   ├── routes/         
│   │   └── services/      
├── tests/                 
│   ├── unit/              
│   └── integration/      
├── package.json          
├── .env                  
└── README.md   

go-project/
├── cmd/                  
│   └── main/             
├── internal/             
│   ├── handlers/         
│   ├── models/           
│   └── services         
└── pkg/                  
    └── utils/              

flutter-project/
├── lib/                   
│   ├── app.dart           
│   ├── main.dart          
│   └── config/           
├── core/                  
│   ├── network/           
│   ├── utils/             
│   └── widgets/          
└── features/             
    └── auth/              
```

## Environment Variables

For Node.js projects, following environment variables are supported:

- PORT
- DB_HOST
- DB_PORT
- DB_NAME
- DB_USER
- DB_PASSWORD
- JWT_SECRET
- LOG_LEVEL

## Development

After generating a project, you can:

Node.js/TypeScript:
```bash
npm install
npm start
```

Flutter:
```bash
flutter pub get
flutter run
```

Go:
```bash
go run cmd/main/main.go
```

## Notes

- This script creates a basic structure and you might need to add more configurations
- For Node.js projects, make sure to copy `.env.example` to `.env`
- Database connection details need to be updated in `.env`
- The script initializes a Git repository for version control

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

Distributed under the ISC License. See LICENSE for more information.
