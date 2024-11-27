Digital Blood Pressure Management System

Overview
The Digital Blood Pressure Management System is a cross-platform healthcare solution designed to help patients and doctors efficiently manage blood pressure data. The application integrates a robust Django REST Framework backend with an intuitive Flutter frontend, offering personalized insights powered by Gemini 1.5 Flash AI.

Features
For Patients
🌟 Account Management: Register and log in to a secure account.
📊 Record Readings: Log systolic and diastolic blood pressure values.
💡 Personalized Recommendations: Get AI-generated health suggestions based on your latest readings.
For Doctors
👩‍⚕️ Access Dashboard: Securely log in to view patient records.
📂 Filter and Monitor: Search patients by username and track blood pressure trends.
🔍 Analyze Data: Use insights to provide timely medical advice.
Tech Stack
Backend
🐍 Django: RESTful API for seamless data exchange.
🔑 Custom User Model: Separate roles for doctors and patients.
🤖 Gemini 1.5 Flash AI: Generates personalized health recommendations.
Frontend
🎨 Flutter: Modern UI framework for a responsive and interactive experience.
🌐 API Integration: Communicates with the backend via RESTful APIs.
How It Works
1. Patient Workflow
Register or log in via the app.
Enter blood pressure readings.
Receive personalized recommendations.

2. Doctor Workflow
Log in to access the dashboard.
View and filter patient readings.
Analyze data trends.

Setup Instructions
Backend (Django)
Clone the repository:
bash
Copy code
git clone [https://github.com/github.com/Nguchie/Repositories/BP](https://github.com/Nguchie/BP)
cd backend
Install dependencies:
bash
Copy code
pip install -r requirements.txt
Run migrations:
bash
Copy code
python manage.py migrate
Start the development server:
bash
Copy code
python manage.py runserver
Frontend (Flutter)
Navigate to the frontend directory:
bash
Copy code
cd frontend
Install Flutter dependencies:
bash
Copy code
flutter pub get
Run the app on a connected device or emulator:
bash
Copy code
flutter run
Sample Screenshots
Patient Dashboard
![user](https://github.com/user-attachments/assets/0a0bdfd8-bdd4-4b8e-9478-2ee4e070326c)

Doctor Dashboard
![doc](https://github.com/user-attachments/assets/b691fd2b-9205-4338-98d5-5116c9c8b069)

Future Enhancements
🔔 Notifications for abnormal readings.
🌍 Multilingual support.
