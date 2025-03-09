#!/bin/bash

# Colors for better visibility
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
NC="\033[0m" # No Color

# Function to display banner
display_banner() {
    echo -e "\n${BLUE}================================================${NC}"
    echo -e "${GREEN}          Project Structure Generator          ${NC}"
    echo -e "${BLUE}================================================${NC}\n"
}

# Function to create Flutter project with clean architecture
create_flutter_structure() {
    local project_name="$1"
    local org="$2"
    
    echo -e "${GREEN}Creating Flutter project: ${BLUE}$project_name${NC}"
    
    # Run the Flutter create command with the organization parameter
    flutter create --org "$org" "$project_name"
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to create Flutter project. Make sure Flutter is installed correctly.${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}Flutter project created successfully. Setting up Clean Architecture...${NC}"
    
    # Navigate to the project directory
    cd "$project_name"
    
    # Create Clean Architecture folder structure in the lib folder
    echo -e "${GREEN}Creating Clean Architecture folder structure in ${BLUE}lib${NC}"

    # Backup the main.dart file
    cp lib/main.dart lib/main.dart.bak
    
    # Create main folder structure
    mkdir -p "lib/core/constants"
    mkdir -p "lib/core/errors"
    mkdir -p "lib/core/network"
    mkdir -p "lib/core/usecases"
    mkdir -p "lib/core/utils"
    mkdir -p "lib/core/widgets"

    # Create feature-based folders following clean architecture
    mkdir -p "lib/features"

    # Create common layers for a sample feature (auth)
    # You can repeat this pattern for other features
    mkdir -p "lib/features/auth/data/datasources/local"
    mkdir -p "lib/features/auth/data/datasources/remote"
    mkdir -p "lib/features/auth/data/models"
    mkdir -p "lib/features/auth/data/repositories"
    mkdir -p "lib/features/auth/domain/entities"
    mkdir -p "lib/features/auth/domain/repositories"
    mkdir -p "lib/features/auth/domain/usecases"
    mkdir -p "lib/features/auth/presentation/bloc"
    mkdir -p "lib/features/auth/presentation/pages"
    mkdir -p "lib/features/auth/presentation/widgets"

    # Create config folder
    mkdir -p "lib/config/routes"
    mkdir -p "lib/config/themes"

    # Create Di (Dependency Injection) folder
    mkdir -p "lib/di"

    # Create test directories matching the structure
    mkdir -p "test/features/auth/data"
    mkdir -p "test/features/auth/domain"
    mkdir -p "test/features/auth/presentation"
    mkdir -p "test/core"

    # Create placeholder files to maintain git structure
    touch "lib/app.dart"
    touch "lib/di/injection_container.dart"
    touch "lib/core/constants/app_constants.dart"
    touch "lib/core/errors/failures.dart"
    touch "lib/core/errors/exceptions.dart"
    touch "lib/core/network/network_info.dart"
    touch "lib/core/usecases/usecase.dart"
    touch "lib/config/routes/app_routes.dart"
    touch "lib/config/themes/app_theme.dart"
    
    # Create the main.dart file with clean architecture setup
    cat > "lib/main.dart" << EOF
import 'package:flutter/material.dart';
import 'app.dart';
import 'di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependencies
  await di.init();
  
  runApp(const MyApp());
}
EOF

    # Create the app.dart file
    cat > "lib/app.dart" << EOF
import 'package:flutter/material.dart';
import 'config/routes/app_routes.dart';
import 'config/themes/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '$project_name',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      // TODO: Initialize router
      home: const Scaffold(
        body: Center(
          child: Text('Welcome to Clean Architecture'),
        ),
      ),
    );
  }
}
EOF

    # Create the dependency injection file
    cat > "lib/di/injection_container.dart" << EOF
// This file will contain the dependency injection setup
// using get_it or any other DI solution

Future<void> init() async {
  // Features
  
  // Core
  
  // External
}
EOF

    # Create the app_theme.dart file
    cat > "lib/config/themes/app_theme.dart" << EOF
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.dark,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
EOF

    # Create the usecase.dart file
    cat > "lib/core/usecases/usecase.dart" << EOF
import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

// Parameters have to be put into a container object
abstract class Params {}

// This is for usecases that don't need parameters
class NoParams extends Params {}

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
EOF

    # Create the failures.dart file
    cat > "lib/core/errors/failures.dart" << EOF
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

// General failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class NetworkFailure extends Failure {}
EOF

    # Create the README.md file
    cat > "README.md" << EOF
# $project_name

A Flutter project with Clean Architecture.

## Project Structure

The project follows Clean Architecture principles with the following structure:

\`\`\`
lib/
├── app.dart                # Main app widget
├── main.dart               # Entry point
├── config/                 # App configuration
│   ├── routes/             # App routes
│   └── themes/             # App themes
├── core/                   # Core functionality
│   ├── constants/          # App constants
│   ├── errors/             # Error handling
│   ├── network/            # Network functionality
│   ├── usecases/           # Base usecase classes
│   ├── utils/              # Utility functions
│   └── widgets/            # Common widgets
├── di/                     # Dependency injection
└── features/               # App features
    └── auth/               # Auth feature (example)
        ├── data/           # Data layer
        │   ├── datasources/# Data sources
        │   ├── models/     # Data models
        │   └── repositories/# Repository implementations
        ├── domain/         # Domain layer
        │   ├── entities/   # Business entities
        │   ├── repositories/# Repository interfaces
        │   └── usecases/   # Business usecases
        └── presentation/   # Presentation layer
            ├── bloc/       # State management
            ├── pages/      # UI pages
            └── widgets/    # UI widgets
\`\`\`

## Clean Architecture

This project follows Clean Architecture principles:

1. **Domain Layer**: Contains business logic and rules, entities, and use cases.
2. **Data Layer**: Implements repositories defined in the domain layer, handles data sources.
3. **Presentation Layer**: UI components and state management.

## Getting Started

1. Add required dependencies to pubspec.yaml:

\`\`\`
dependencies:
  flutter:
    sdk: flutter
  # State Management
  flutter_bloc: ^8.1.0
  # Dependency Injection
  get_it: ^7.2.0
  # Functional Programming
  dartz: ^0.10.1
  # Value Equality
  equatable: ^2.0.5
  # Remote API
  http: ^0.13.5
  # Local Cache
  shared_preferences: ^2.0.15

dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.3.2
  build_runner: ^2.3.0
\`\`\`

2. Run \`flutter pub get\` to install dependencies

3. Start building your features!

## Dependencies

- **Flutter Bloc**: For state management
- **Get It**: For dependency injection
- **Dartz**: For functional programming (Either type)
- **Equatable**: For value equality
- **Http**: For API calls
- **Shared Preferences**: For local storage

## Adding New Features

To add a new feature:

1. Create a new folder in the features directory
2. Follow the same structure (data, domain, presentation)
3. Register dependencies in the dependency injection container
4. Add routes if needed

## Running Tests

\`\`\`
flutter test
\`\`\`

This project is organized to make testing easier with clear separation of concerns.
EOF

    # Update pubspec.yaml to include necessary packages
    echo -e "${YELLOW}Updating pubspec.yaml with required dependencies...${NC}"
    cat >> "pubspec.yaml" << EOF

# The following dependencies were added for Clean Architecture
  # State Management
  flutter_bloc: ^8.1.0
  # Dependency Injection
  get_it: ^7.2.0
  # Functional Programming
  dartz: ^0.10.1
  # Value Equality
  equatable: ^2.0.5
  # Remote API
  http: ^0.13.5
  # Local Cache
  shared_preferences: ^2.0.15
EOF

    cd ..
    
    echo -e "\n${GREEN}Flutter project with Clean Architecture created successfully!${NC}"
    echo -e "${YELLOW}Don't forget to run 'flutter pub get' to install the additional dependencies.${NC}"
}

# Function to create Go project structure
create_go_structure() {
    local project_name="$1"
    
    echo -e "${GREEN}Creating Go project structure for ${BLUE}$project_name${NC}"

    # Create project root directory
    mkdir -p "${project_name}"

    # Create directory structure
    mkdir -p "${project_name}/cmd/${project_name}" \
             "${project_name}/internal/config" \
             "${project_name}/internal/handlers" \
             "${project_name}/internal/models" \
             "${project_name}/internal/services" \
             "${project_name}/pkg/utils" \
             "${project_name}/api" \
             "${project_name}/web" \
             "${project_name}/configs" \
             "${project_name}/scripts" \
             "${project_name}/test" \
             "${project_name}/docs"

    # Create main.go entry point
    touch "${project_name}/cmd/${project_name}/main.go"

    # Initialize Go module
    (cd "${project_name}" && go mod init "$project_name" 2>/dev/null)

    # Create README.md
    cat > "${project_name}/README.md" << EOF
# ${project_name}

A Go project with a clean and organized structure.

## Project Structure

\`\`\`
${project_name}/
├── api/                # API definitions (like proto files, OpenAPI specs)
├── cmd/                # Main applications
│   └── ${project_name}/    # Main application entry point
├── configs/            # Configuration files
├── docs/               # Documentation files
├── internal/           # Private application code
│   ├── config/         # Internal configuration
│   ├── handlers/       # HTTP handlers
│   ├── models/         # Data models
│   └── services/       # Business logic
├── pkg/                # Public library code
│   └── utils/          # Utility functions
├── scripts/            # Scripts for development, CI, etc.
├── test/               # Additional test files
└── web/                # Web assets
\`\`\`

## Getting Started

\`\`\`bash
# Run the application
go run cmd/${project_name}/main.go
\`\`\`
EOF

    # Create .gitignore
    cat > "${project_name}/.gitignore" << EOF
# Binaries for programs and plugins
*.exe
*.exe~
*.dll
*.so
*.dylib

# Test binary, built with go test -c
*.test

# Output of the go coverage tool
*.out

# Go workspace file
go.work

# Binary output
bin/

# IDE specific files
.idea/
.vscode/
*.swp
*.swo

# OS specific files
.DS_Store
EOF

    echo -e "\n${GREEN}Go project structure created successfully!${NC}"
}

# Function to create Node.js project structure
create_nodejs_structure() {
    local project_name="$1"
    
    echo -e "\n${GREEN}Creating Node.js project structure for:${NC} ${BLUE}$project_name${NC}\n"

    # Create the project directory
    mkdir -p "$project_name"
    cd "$project_name"

    # Function to create directory and print status
    create_dir() {
        mkdir -p "$1"
        echo -e "${GREEN}Created:${NC} $1"
    }

    # Function to create a simple file with content
    create_file() {
        local file_path="$1"
        local content="$2"
        
        # Create the directory if it doesn't exist
        local dir_path=$(dirname "$file_path")
        mkdir -p "$dir_path"
        
        # Create the file with content
        echo -e "$content" > "$file_path"
        echo -e "${BLUE}Created file:${NC} $file_path"
    }

    # Create standard directories
    create_dir "src/api/controllers"
    create_dir "src/api/middlewares"
    create_dir "src/api/routes"
    create_dir "src/api/services"
    create_dir "src/api/validators"
    create_dir "src/config"
    create_dir "src/db/models"
    create_dir "src/db/migrations"
    create_dir "src/db/seeders"
    create_dir "src/utils"
    create_dir "src/helpers"
    create_dir "public/assets/images"
    create_dir "public/assets/css"
    create_dir "public/assets/js"
    create_dir "views"
    create_dir "tests/unit"
    create_dir "tests/integration"
    create_dir "scripts"
    create_dir "logs"

    # Create initial package.json
    create_file "package.json" '{
  "name": "'$project_name'",
  "version": "1.0.0",
  "description": "A Node.js application",
  "main": "src/index.js",
  "scripts": {
    "start": "node src/index.js",
    "dev": "nodemon src/index.js",
    "test": "jest",
    "lint": "eslint src/",
    "lint:fix": "eslint src/ --fix"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "dependencies": {
    "express": "^4.18.2",
    "dotenv": "^16.3.1",
    "winston": "^3.10.0"
  },
  "devDependencies": {
    "eslint": "^8.47.0",
    "jest": "^29.6.2",
    "nodemon": "^3.0.1"
  }
}'

    # Create main app file
    create_file "src/index.js" "const express = require('express');
const path = require('path');
const config = require('./config');
const logger = require('./utils/logger');
const routes = require('./api/routes');

// Initialize express app
const app = express();

// Middleware setup
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, '../public')));

// Routes
app.use('/api', routes);

// Default route
app.get('/', (req, res) => {
  res.send('Welcome to $project_name API');
});

// Error handler
app.use((err, req, res, next) => {
  logger.error(err.stack);
  res.status(500).send('Something broke!');
});

// Start server
const PORT = config.port || 3000;
app.listen(PORT, () => {
  logger.info(\`Server is running on port \${PORT}\`);
});

module.exports = app; // For testing
"

    # Create config file
    create_file "src/config/index.js" "require('dotenv').config();

module.exports = {
  port: process.env.PORT || 3000,
  nodeEnv: process.env.NODE_ENV || 'development',
  dbConfig: {
    host: process.env.DB_HOST || 'localhost',
    port: process.env.DB_PORT || 5432,
    database: process.env.DB_NAME || '$project_name',
    username: process.env.DB_USER || 'postgres',
    password: process.env.DB_PASSWORD || 'postgres'
  },
  jwtSecret: process.env.JWT_SECRET || 'your-secret-key',
  // Add other configuration as needed
};
"

    # Create logger utility
    create_file "src/utils/logger.js" "const winston = require('winston');
const path = require('path');

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  defaultMeta: { service: '$project_name' },
  transports: [
    // Write all logs to console
    new winston.transports.Console({
      format: winston.format.combine(
        winston.format.colorize(),
        winston.format.simple()
      ),
    }),
    // Write all logs to file
    new winston.transports.File({
      filename: path.join(__dirname, '../../logs/error.log'),
      level: 'error',
    }),
    new winston.transports.File({
      filename: path.join(__dirname, '../../logs/combined.log'),
    }),
  ],
});

module.exports = logger;
"

    # Create routes index
    create_file "src/api/routes/index.js" "const express = require('express');
const router = express.Router();

// Import route modules
// const userRoutes = require('./user.routes');
// const authRoutes = require('./auth.routes');

// Define routes
// router.use('/users', userRoutes);
// router.use('/auth', authRoutes);

// Health check route
router.get('/health', (req, res) => {
  res.status(200).json({ status: 'OK', message: 'Server is healthy' });
});

module.exports = router;
"

    # Create a sample controller
    create_file "src/api/controllers/sample.controller.js" "/**
 * Sample controller with CRUD operations
 */

// Get all items
exports.getAll = async (req, res, next) => {
  try {
    // Logic to get all items
    res.status(200).json({ message: 'Get all items' });
  } catch (error) {
    next(error);
  }
};

// Get item by ID
exports.getById = async (req, res, next) => {
  try {
    const { id } = req.params;
    // Logic to get item by ID
    res.status(200).json({ message: \`Get item with ID \${id}\` });
  } catch (error) {
    next(error);
  }
};

// Create a new item
exports.create = async (req, res, next) => {
  try {
    const data = req.body;
    // Logic to create a new item
    res.status(201).json({ message: 'Item created successfully', data });
  } catch (error) {
    next(error);
  }
};

// Update an item
exports.update = async (req, res, next) => {
  try {
    const { id } = req.params;
    const data = req.body;
    // Logic to update the item
    res.status(200).json({ message: \`Item \${id} updated successfully\`, data });
  } catch (error) {
    next(error);
  }
};

// Delete an item
exports.delete = async (req, res, next) => {
  try {
    const { id } = req.params;
    // Logic to delete the item
    res.status(200).json({ message: \`Item \${id} deleted successfully\` });
  } catch (error) {
    next(error);
  }
};
"

    # Create a sample service
    create_file "src/api/services/sample.service.js" "/**
 * Sample service with business logic
 */

// Get all items
exports.findAll = async () => {
  try {
    // Database query or other logic
    return [
      { id: 1, name: 'Item 1' },
      { id: 2, name: 'Item 2' }
    ];
  } catch (error) {
    throw error;
  }
};

// Get item by ID
exports.findById = async (id) => {
  try {
    // Database query or other logic
    return { id, name: \`Item \${id}\` };
  } catch (error) {
    throw error;
  }
};

// Create a new item
exports.create = async (data) => {
  try {
    // Database insert or other logic
    return { id: Date.now(), ...data };
  } catch (error) {
    throw error;
  }
};

// Update an item
exports.update = async (id, data) => {
  try {
    // Database update or other logic
    return { id, ...data };
  } catch (error) {
    throw error;
  }
};

// Delete an item
exports.delete = async (id) => {
  try {
    // Database delete or other logic
    return true;
  } catch (error) {
    throw error;
  }
};
"

    # Create a sample middleware
    create_file "src/api/middlewares/auth.middleware.js" "/**
 * Authentication middleware
 */

exports.authenticate = (req, res, next) => {
  try {
    // Get token from header
    const authHeader = req.headers.authorization;
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ message: 'Authentication required' });
    }
    
    const token = authHeader.split(' ')[1];
    
    // Verify token (implement your token verification logic)
    // const decoded = jwt.verify(token, config.jwtSecret);
    // req.user = decoded;
    
    next();
  } catch (error) {
    return res.status(401).json({ message: 'Invalid token' });
  }
};

exports.authorize = (roles = []) => {
  return (req, res, next) => {
    // Ensure user exists after authentication
    if (!req.user) {
      return res.status(401).json({ message: 'Authentication required' });
    }
    
    // Check if user role is permitted
    if (roles.length && !roles.includes(req.user.role)) {
      return res.status(403).json({ message: 'Forbidden: insufficient permissions' });
    }
    
    next();
  };
};
"

    # Create .env file
    create_file ".env" "# Server Configuration
NODE_ENV=development
PORT=3000

# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=$project_name
DB_USER=postgres
DB_PASSWORD=postgres

# JWT Configuration
JWT_SECRET=your-secret-key

# Logging
LOG_LEVEL=info
"

    # Create .env.example file
    create_file ".env.example" "# Server Configuration
NODE_ENV=development
PORT=3000

# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=dbname
DB_USER=username
DB_PASSWORD=password

# JWT Configuration
JWT_SECRET=your-secret-key

# Logging
LOG_LEVEL=info
"

    # Create .gitignore file
    create_file ".gitignore" "# Dependencies
node_modules/
npm-debug.log
yarn-debug.log
yarn-error.log

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Build output
dist/
build/

# Logs
logs/
*.log

# Coverage directory used by tools like istanbul
coverage/

# Editor directories and files
.idea/
.vscode/
*.suo
*.ntvs*
*.njsproj
*.sln
*.sw?

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
"

    # Create README.md
    create_file "README.md" "# $project_name

A Node.js application with an organized and scalable structure.

## Project Structure

\`\`\`
$project_name/
├── src/                    # Source files
│   ├── api/                # API related files
│   │   ├── controllers/    # Request handlers
│   │   ├── middlewares/    # Express middlewares
│   │   ├── routes/         # Route definitions
│   │   ├── services/       # Business logic
│   │   └── validators/     # Input validation
│   ├── config/             # Configuration files
│   ├── db/                 # Database related files
│   │   ├── models/         # Database models
│   │   ├── migrations/     # Database migrations
│   │   └── seeders/        # Database seeders
│   ├── utils/              # Utility functions
│   ├── helpers/            # Helper functions
│   └── index.js            # Application entry point
├── public/                 # Static files
│   └── assets/             # Asset files (images, css, js)
├── views/                  # View templates (if using a view engine)
├── tests/                  # Test files
│   ├── unit/               # Unit tests
│   └── integration/        # Integration tests
├── scripts/                # Scripts for deployment, etc.
├── logs/                   # Log files
├── package.json            # Project metadata and dependencies
├── .env                    # Environment variables
├── .env.example            # Example environment variables
├── .gitignore              # Git ignore rules
└── README.md               # Project documentation
\`\`\`

## Installation

\`\`\`bash
# Clone the repository
git clone <repository-url>
cd $project_name

# Install dependencies
npm install

# Copy environment variables
cp .env.example .env
# Edit .env to match your environment

# Start the server
npm start
\`\`\`

## Development

\`\`\`bash
# Run in development mode with hot reload
npm run dev

# Run tests
npm test

# Lint code
npm run lint

# Fix linting issues
npm run lint:fix
\`\`\`

## API Endpoints

- GET /api/health - Health check endpoint
- Additional endpoints will be documented here

## License

ISC
"

    # Create a basic Jest config for testing
    create_file "jest.config.js" "module.exports = {
  testEnvironment: 'node',
  coverageDirectory: 'coverage',
  collectCoverageFrom: [
    'src/**/*.js',
    '!src/index.js',
  ],
  testMatch: [
    '**/tests/**/*.test.js',
  ],
};
"

    # Create a sample test file
    create_file "tests/unit/sample.test.js" "describe('Sample Test Suite', () => {
  test('should pass a simple test', () => {
    expect(1 + 1).toBe(2);
  });
});
"

    # Create a basic ESLint config
    create_file ".eslintrc.js" "module.exports = {
  env: {
    node: true,
    commonjs: true,
    es2021: true,
    jest: true,
  },
  extends: 'eslint:recommended',
  parserOptions: {
    ecmaVersion: 12,
  },
  rules: {
    'no-console': 'warn',
    'no-unused-vars': ['error', { argsIgnorePattern: 'next' }],
  },
};
"

    # Initialize git repository
    git init > /dev/null 2>&1
    echo -e "${BLUE}Initialized Git repository${NC}"

    # Return to the parent directory
    cd ..

    echo -e "\n${GREEN}Node.js project structure created successfully!${NC}"
}

# Main script starts here
display_banner

# Display project type options
echo -e "Please select the type of project structure to create:"
echo -e "${BLUE}1)${NC} Flutter (Clean Architecture)"
echo -e "${BLUE}2)${NC} Go"
echo -e "${BLUE}3)${NC} Node.js"
echo -e "${BLUE}q)${NC} Quit"

# Get user choice
read -p "Enter your choice (1/2/3/q): " project_choice

case $project_choice in
    q|Q)
        echo -e "\n${YELLOW}Exiting...${NC}"
        exit 0
        ;;
    1|2|3)
        # Valid choice, continue
        ;;
    *)
        echo -e "\n${RED}Invalid choice. Exiting...${NC}"
        exit 1
        ;;
esac

# For Flutter, get both project name and organization identifier
if [ "$project_choice" == "1" ]; then
    read -p "Enter Flutter project name: " project_name

    if [ -z "$project_name" ]; then
        echo -e "${RED}Project name cannot be empty. Exiting...${NC}"
        exit 1
    fi

    read -p "Enter organization identifier (e.g., com.example): " org_identifier

    if [ -z "$org_identifier" ]; then
        echo -e "${YELLOW}Using default organization: com.example${NC}"
        org_identifier="com.example"
    fi

    # Confirm the project creation
    echo -e "\n${YELLOW}You are about to create a Flutter project named '${project_name}' with organization '${org_identifier}'.${NC}"
    read -p "Do you want to continue? (y/n): " confirm

    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        echo -e "\n${YELLOW}Operation cancelled.${NC}"
        exit 0
    fi
else
    read -p "Enter project name: " project_name

    if [ -z "$project_name" ]; then
        echo -e "${RED}Project name cannot be empty. Exiting...${NC}"
        exit 1
    fi
fi

# Create the selected project structure
case $project_choice in
    1)
        create_flutter_structure "$project_name" "$org_identifier"
        ;;
    2)
        create_go_structure "$project_name"
        ;;
    3)
        create_nodejs_structure "$project_name"
        ;;
esac

# Display completion message
echo -e "\n${GREEN}Project setup completed!${NC}"
echo -e "${BLUE}Project location:${NC} $(pwd)/${project_name}"
echo -e "${YELLOW}Happy coding!${NC}\n"
