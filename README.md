## **MovieQuiz**

MovieQuiz -  Quiz app featuring questions about the top-250 highest-rated films according to IMDb rankings.

## **Links**

[Design Figma](https://www.figma.com/file/l0IMG3Eys35fUrbvArtwsR/YP-Quiz?node-id=34%3A243)

[API IMDb](https://imdb-api.com/api#Top250Movies-header)

[Fonts](https://code.s3.yandex.net/Mobile/iOS/Fonts/MovieQuizFonts.zip)

## **Application description**

- Single-page application with quizes about top-250 the most popular IMDb movies. The user of the application answers questions about the movie ratings sequantially. At the end of each round of the game, statistics are displayed on the number of correct answers and the user's best results. The goal of the game is to correctly answer all 10 questions in a round.

## **Functional requirements**

- A splash screen is displayed, when the application is launched;
- After the application is launched, screen appears with the question text, an image, and two buttons - "Yes" and "No" with only one of them being correct;
- Questions are based on the IMDb movie rating on a 10-point scale, for example: "Is the rating of this movie higher than 6?";
- When you click on an answer button, the user receives feedback on whether their answer is correct or not, and the photo frame changes color accordingly;
- After selecting an answer for a question, the next question automatically appears after 1 second;
- When user completes a round of 10 questions, appears an alert with statistics and an option to play again;
- The statistics include: the current round's result (number of correct answers out of 10 questions), the total number of played quizzes, the record (best round result of the session, date, and time of that round), and the statistics of played quizzes in percentage (average accuracy);
- The user can start a new round by pressing the "Play Again" button in the alert;
- If data cannot be loaded, the user sees an alert with a message indicating that something went wrong, along with a button to retry the network request.

## **Technical requirements**

- The application should support iPhone devices with iOS 13, and only portrait mode is provided.
- Interface elements are adapted for the screen resolutions of larger iPhones (13, 13 Pro Max); layout for the SE and iPad is not provided.
- The screens correspond to the layout; the correct fonts of the required sizes are used, all labels are in the right places, the arrangement of all elements, button sizes, and margins are exactly the same as in the layout.
