/// AUTO-GENERATED FILE, DO NOT MODIFY
var titleList = ['Basic Cannon','Random Direction','Fireworks'];
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

  int count = (progress / total * 50).toInt();

  Confetti.launch(
    context,
    options: ConfettiOptions(
        particleCount: count,
        x: randomInRange(0.1, 0.3),
        y: Random().nextDouble() - 0.2),
  );
  Confetti.launch(
    context,
    options: ConfettiOptions(
        particleCount: count,
        x: randomInRange(0.7, 0.9),
        y: Random().nextDouble() - 0.2),
  );
});

'''];

getCodeByTitle(title) {
final index = titleList.indexOf(title);
if (index == -1) {
  return null;
}
  return codeList[index];
}
