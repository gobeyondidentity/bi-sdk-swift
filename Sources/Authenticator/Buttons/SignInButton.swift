import Foundation
import SharedDesign

#if os(iOS)
func SignInButton(title: String) -> PrimaryButton {
    PrimaryButton(
        title: title,
        backgroundColor: Color.primaryButtonColor,
        borderColor: Color.primaryButtonColor,
        imageColor: Color.primaryButtonText,
        titleColor: Color.primaryButtonText
    )
}
#endif
