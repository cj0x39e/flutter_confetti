/// AUTO-GENERATED FILE, DO NOT MODIFY
var titleList = ['Basic Cannon','Random Direction','Fireworks','Stars'];
var codeList = ['''

Confetti.launch(
  context,
  options: const ConfettiOptions(
      particleCount: 100, spread: 70, y: 0.6),
);

''','''
double randomInRange(double min, double max) {
  return min + Random().nextDouble() * (max - min);
}

Confetti.launch(
  context,
  options: ConfettiOptions(
      angle: randomInRange(55, 125),
      spread: randomInRange(50, 70),
      particleCount: randomInRange(50, 100).toInt(),
      y: 0.6),
);

''','''
double randomInRange(double min, double max) {
  return min + Random().nextDouble() * (max - min);
}

int total = 60;
int progress = 0;

Timer.periodic(const Duration(milliseconds: 250), (timer) {
  progress++;

  if (progress >= total) {
    timer.cancel();
    return;
  }

  int count = ((1 - progress / total) * 50).toInt();

  Confetti.launch(
    context,
    options: ConfettiOptions(
        particleCount: count,
        startVelocity: 30,
        spread: 360,
        ticks: 60,
        x: randomInRange(0.1, 0.3),
        y: Random().nextDouble() - 0.2),
  );
  Confetti.launch(
    context,
    options: ConfettiOptions(
        particleCount: count,
        startVelocity: 30,
        spread: 360,
        ticks: 60,
        x: randomInRange(0.7, 0.9),
        y: Random().nextDouble() - 0.2),
  );
});

''','''

const options = ConfettiOptions(
    spread: 360,
    ticks: 50,
    gravity: 0,
    decay: 0.94,
    startVelocity: 30,
    colors: [
      Color(0xffFFE400),
      Color(0xffFFBD00),
      Color(0xffE89400),
      Color(0xffFFCA6C),
      Color(0xffFDFFB8)
    ]);

shoot() {
  Confetti.launch(context,
      options:
          options.copyWith(particleCount: 40, scalar: 1.2),
      particleBuilder: (index) => Star());
  Confetti.launch(context,
      options: options.copyWith(
        particleCount: 10,
        scalar: 0.75,
      ));
}

Timer(Duration.zero, shoot);
Timer(const Duration(milliseconds: 100), shoot);
Timer(const Duration(milliseconds: 200), shoot);

'''];

getCodeByTitle(title) {
final index = titleList.indexOf(title);
if (index == -1) {
  return null;
}
  return codeList[index];
}
