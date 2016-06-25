import UIKit

class FAQDetailVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var answerLbl: UILabel!
    var detailFAQ: FAQModel?
    override func viewDidLoad() {
        configureView()
    }
	
    func configureView() {
        if let faq = detailFAQ {
            questionLbl.text = faq.question.localized()
			answerLbl.text = faq.answer.localized()
        }
    }
}
