abstract class FormSubmissionStatus {
  const FormSubmissionStatus();
}

class InitialFormStatus extends FormSubmissionStatus {
  const InitialFormStatus();
}

class FormSubmitting extends FormSubmissionStatus {}

class FormEditing extends FormSubmissionStatus {}

class SubmissionSuccess extends FormSubmissionStatus {
  final String message;
  SubmissionSuccess({required this.message});
}

class SubmissionFailed extends FormSubmissionStatus {
  final  String message;

  SubmissionFailed(this.message);
}