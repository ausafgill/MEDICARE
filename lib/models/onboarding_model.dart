class OnboardingModel {
  final String img;
  final String des;
  OnboardingModel({required this.img, required this.des});
  static List<OnboardingModel> list = [
    OnboardingModel(
        img: 'assets/images/ob1.png',
        des:
            'Medicare is your personalized pharmacy at your fingertips, making healthcare management effortless'),
    OnboardingModel(
        img: 'assets/images/ob2.png',
        des:
            'Experience the convenience of having your medicines delivered right to your doorstep'),
    OnboardingModel(
        img: 'assets/images/ob3.png',
        des:
            "Expand your pharmacy's reach and connect with patients seamlessly by registering with Medicare"),
  ];
}
