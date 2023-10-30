

App architecture:
    -> config Directory:
        Theme and Color Config Files: Centralizing theme and color configurations here enables easy access and modification of the app's theme across multiple views. This helps maintain consistent branding and user interface design.

    -> constants Directory:
        Ideal for storing app-level constant values, enums, or static data used throughout the application. This separation helps in centralizing and accessing these constants when needed.

    -> helpers Directory:
        Often used for utility functions, conversions, or general helper methods that can be used across different sections of your app.

    services Directory:
      function: 
       blocs Subdirectory: Storing all BLoC-related files according to the type of service it provides is a great way to organize your business logic. It keeps BLoCs separate and easily accessible when needed. Separating this directory for BLoC implementation aligns well with the clean separation of concerns.
        cloud_services Subdirectory: This might contain services for interacting with cloud-based services, APIs, or Firebase. This segregation helps in isolating cloud interaction logic from other components. It's with the blocFolder, making it easy to navigate while working on bloc.

    utilities Directory:
        Useful for general utility classes, extensions, or functionalities that don't belong to a specific section but can be utilized globally.

    views Directory:
        Subdirectories (e.g., auth, home, ): Grouping views based on their functionality or user interface segments is a good practice. Each subdirectory can contain related screens, widgets, services or UI components.



**App features:
-Firebase email-password registration/login
-User can save their day to day expenses and income.

DemoVideo: https://drive.google.com/file/d/17qRgnq7AHcNhg0le3plJmBby_8Kx3a6t/view?usp=sharing

![HomePage](https://drive.google.com/file/d/17sjQyL5FJcHST4kF9fGyQ3R-mpgRdfiA/view?usp=sharing)
![AddTransactions](https://drive.google.com/file/d/17rx4_WV1daWWMboxKikUSEOhUJb7za0_/view?usp=sharing)
![BottomSheet](https://drive.google.com/file/d/17rg4_AWaRhaYC4hzOXyPfv3c2qDTEhM_/view?usp=sharing)