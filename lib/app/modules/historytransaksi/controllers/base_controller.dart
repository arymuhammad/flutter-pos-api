import 'package:my_first_app/app/helper/dialog_helper.dart';
import 'package:my_first_app/app/service/app_exceptions.dart';

class BaseController {
   void handleError(error) {
    hideLoading();
    if (error is BadRequestException) {
      var message = error.message;
      DialogHelper().showErroDialog(description: message);
    } else if (error is FetchDataException) {
      var message = error.message;
      DialogHelper().showErroDialog(description: message);
    } else if (error is ApiNotRespondingException) {
      DialogHelper().showErroDialog(
          description: 'Oops! It took longer to respond.');
    }
  }

  showLoading([String? message]) {
    DialogHelper.showLoading(message);
  }

  hideLoading() {
    DialogHelper.hideLoading();
  }
}