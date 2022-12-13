import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    //MARK: Private Outlet Variables
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    
    //MARK: Private Variables
    private var presenter : MovieQuizPresenter!        // инъекция Presenter
    
    //MARK:  Functions
    //метод показывающий вопрос в квизе
    func show(quiz step: QuizStepViewModel ) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.layer.cornerRadius = 20
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        
    }
    func imageBorderAppearence(isCorrect: Bool) {
        imageView.layer.masksToBounds = true        //закругление углов картинки
        imageView.layer.borderWidth = 8             //ширина доп рамки
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor //в зависимости                                               от правильности ответов рамка цвета зеленого или красного
        imageView.layer.cornerRadius = 20                   //радиус закругления
        self.yesButton.isEnabled = false                    // кнопка да недоступна
        self.noButton.isEnabled = false                     // кнопка нет недоступна
    }
    func buttonEnable() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in  //диспетчер очереди работающий через секунду после нажатия
            guard let self = self else { return }
            self.presenter.proceedToTheQuestionOrResults()  //метод показывающий следующий вопрос или результат
            self.noButton.isEnabled = true  // кнопка нет доступна
            self.yesButton.isEnabled = true // кнопка да доступна
            self.imageView.layer.borderColor = .none //убирается цвет рамки ответа
            self.imageView.layer.borderWidth = 0  // ширина рамки снова 0
        }
    }
    
    // метод который вызывает индикатор загрузки
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    //MARK: IBActions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        showLoadingIndicator()
        presenter.alert = AlertPresenter(viewController: self)
    }
}
