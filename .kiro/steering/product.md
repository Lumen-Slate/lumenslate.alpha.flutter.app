# LumenSlate Product Overview

LumenSlate is an AI-powered teaching assistant designed to lighten teachers' workloads through intelligent automation. The platform focuses on automated assessment and feedback generation for educational content.

## Core Purpose
- **Primary Goal**: Automate grading and feedback for various question types (MCQ, MSQ, NAT, Subjective)
- **Target Users**: Teachers, educators, and coaching centers
- **Value Proposition**: Save teachers hours while providing personalized student feedback

## Key Features
- AI-generated contextual information for questions
- Automated question variation generation for each student
- Prompt-based assignment creation
- Auto-grading with personalized feedback
- Smart question segmentation for complex problems
- Plagiarism reduction through unique variants

## Architecture
- **Frontend**: Flutter Web application (this repository)
- **Backend**: Go + MongoDB (separate repository)
- **AI Services**: gRPC microservice with Vertex AI and Gemini (separate repository)
- **Deployment**: Firebase Hosting (frontend), Google Cloud Run (backend)

## Business Context
This is a private application (`publish_to: "none"`) focused on educational technology with AI-first approach to classroom management and assessment automation.