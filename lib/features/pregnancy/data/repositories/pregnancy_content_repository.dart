import '../../domain/models/week_detail.dart';

class PregnancyContentRepository {
  static final List<WeekDetail> _weeks = [
    WeekDetail(
      weekNumber: 12,
      babySize: 'La taille d\'un citron vert',
      babyDevelopment: 'Les organes du bébé sont formés et commencent à fonctionner. Les réflexes se développent.',
      motherChanges: 'Les nausées diminuent souvent. Votre utérus remonte au-dessus de l\'os pubien.',
      tipOfTheWeek: 'C\'est le bon moment pour planifier votre première échographie morphologique.',
    ),
    WeekDetail(
      weekNumber: 13,
      babySize: 'La taille d\'une grosse prune',
      babyDevelopment: 'Le bébé commence à produire de l\'urine. Ses empreintes digitales se forment.',
      motherChanges: 'Votre libido peut augmenter. Vous commencez à avoir ce "teint éclatant" de grossesse.',
      tipOfTheWeek: 'Commencez à hydrater votre peau pour prévenir les vergetures.',
    ),
    // ... we can add all 40 weeks here
  ];

  WeekDetail getWeekDetail(int week) {
    return _weeks.firstWhere(
      (w) => w.weekNumber == week,
      orElse: () => WeekDetail(
        weekNumber: week,
        babySize: 'En pleine croissance',
        babyDevelopment: 'Votre bébé continue de grandir jour après jour.',
        motherChanges: 'Prenez soin de vous et reposez-vous.',
        tipOfTheWeek: 'N\'oubliez pas de boire beaucoup d\'eau.',
      ),
    );
  }
}
