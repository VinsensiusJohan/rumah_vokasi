import 'package:rumah_vokasi/features/course/models/course_section_model.dart';
import 'package:rumah_vokasi/features/course/models/lesson_option_model.dart';
import 'package:rumah_vokasi/features/mains/models/certificate_model.dart';
import 'package:rumah_vokasi/features/mains/models/course_user_model.dart';
import 'package:rumah_vokasi/features/mains/models/payment_history_model.dart';
import '../features/mains/models/course_model.dart';

//Home + BookMark
final List<Course> courses = [
  Course(
    image: 'assets/nps/course-1.png',
    title: "Pembuatan Dasar Robot",
    name: "Eulogius Kurdeo Hesay S.Kom.",
    rating: 4.6,
    totalReviews: 451444,
    bab: ['Teknik Elektro', 'Mikrokontroler', 'Pemrograman', 'Integrasi Cloud'],
  ),
  Course(
    image: 'assets/nps/course-2.png',
    title: "Elektronika Lanjut",
    name: "Eulogius Kurdeo Hesay S.Kom.",
    rating: 4.6,
    totalReviews: 451444,
    bab: ['Teknik Elektro', 'Mikrokontroler', 'Pemrograman'],
  ),
  Course(
    image: 'assets/nps/course-3.png',
    title: "Koneksi API",
    name: "Eulogius Kurdeo Hesay S.Kom.",
    rating: 4.6,
    totalReviews: 451444,
    bab: ['Teknik Elektro', 'Mikrokontroler', 'Pemrograman'],
  ),
  Course(
    image: 'assets/nps/course-4.png',
    title: "Mikrokontroller",
    name: "Eulogius Kurdeo Hesay S.Kom.",
    rating: 4.6,
    totalReviews: 451444,
    bab: ['Teknik Elektro', 'Mikrokontroler', 'Pemrograman'],
  ),
];

// Paket Page
final List<CourseUser> allCourses = [
  CourseUser(
    image: 'assets/nps/course-1.png',
    title: "Pembuatan Dasar Robot",
    name: "Eulogius Kurdeo Hesay S.Kom.",
    bab: ['Teknik Elektro', 'Mikrokontroler', 'Pemrograman', 'Integrasi Cloud'],
    progress: 0.7,
  ),
  CourseUser(
    image: 'assets/nps/course-2.png',
    title: "Elektronika Lanjut",
    name: "Eulogius Kurdeo Hesay S.Kom.",
    bab: ['Teknik Elektro', 'Mikrokontroler', 'Pemrograman'],
    progress: 1.0,
  ),
  CourseUser(
    image: 'assets/nps/course-3.png',
    title: "Koneksi API",
    name: "Eulogius Kurdeo Hesay S.Kom.",
    bab: ['Teknik Elektro', 'Mikrokontroler', 'Pemrograman'],
    progress: 0.4,
  ),
  CourseUser(
    image: 'assets/nps/course-4.png',
    title: "Mikrokontroller",
    name: "Eulogius Kurdeo Hesay S.Kom.",
    bab: ['Teknik Elektro', 'Mikrokontroler', 'Pemrograman'],
    progress: 1.0,
  ),
];

//dummy
final List<PaymentHistory> histories = [
  PaymentHistory(
    tanggal: '29-10-2025',
    jam: '14:32',
    listKursus: [
      CoursePayment(
        image: 'assets/images/eula-slide-1.png',
        title: 'Dasar Pemrograman Flutter',
        name: 'Budi Santoso',
        bab: ['Flutter Basics', 'Widgets', 'State Management'],
        harga: 150000,
        statusPembayaran: 'Berhasil',
      ),
      CoursePayment(
        image: 'assets/images/eula-slide-2.png',
        title: 'UI Design Principles',
        name: 'Siti Rahma',
        bab: ['Typography', 'Color Theory', 'Layout'],
        harga: 120000,
        statusPembayaran: 'Berhasil',
      ),
    ],
  ),
  PaymentHistory(
    tanggal: '01-11-2025',
    jam: '09:20',
    listKursus: [
      CoursePayment(
        image: 'assets/images/eula-slide-3.png',
        title: 'Teknik Elektro Lanjutan',
        name: 'Agus Pratama',
        bab: ['Sirkuit', 'Arus Listrik', 'Proyek Akhir'],
        harga: 180000,
        statusPembayaran: 'Pending',
      ),
    ],
  ),
  PaymentHistory(
    tanggal: '29-10-2025',
    jam: '14:32',
    listKursus: [
      CoursePayment(
        image: 'assets/images/eula-slide-1.png',
        title: 'Dasar Pemrograman Flutter',
        name: 'Budi Santoso',
        bab: ['Flutter Basics', 'Widgets', 'State Management'],
        harga: 150000,
        statusPembayaran: 'Berhasil',
      ),
      CoursePayment(
        image: 'assets/images/eula-slide-2.png',
        title: 'UI Design Principles',
        name: 'Siti Rahma',
        bab: ['Typography', 'Color Theory', 'Layout'],
        harga: 120000,
        statusPembayaran: 'Berhasil',
      ),
    ],
  ),
  PaymentHistory(
    tanggal: '01-11-2025',
    jam: '09:20',
    listKursus: [
      CoursePayment(
        image: 'assets/images/eula-slide-3.png',
        title: 'Teknik Elektro Lanjutan',
        name: 'Agus Pratama',
        bab: ['Sirkuit', 'Arus Listrik', 'Proyek Akhir'],
        harga: 180000,
        statusPembayaran: 'Pending',
      ),
    ],
  ),
];

// Certificate
final List<Certificate> sertifikat = [
  Certificate(
    image: 'assets/nps/course-1.png',
    title: 'Pembuatan Dasar Robot',
    name: 'Budi Santosa',
    bab: ['Teknik Elektro', 'Mikrokontroler', 'Pemrograman', 'Integrasi Cloud'],
  ),
  Certificate(
    image: 'assets/nps/course-1.png',
    title: 'Pembuatan Dasar Robot',
    name: 'Budi Santosa',
    bab: ['Teknik Elektro', 'Mikrokontroler', 'Pemrograman', 'Integrasi Cloud'],
  ),
  Certificate(
    image: 'assets/nps/course-1.png',
    title: 'Pembuatan Dasar Robot',
    name: 'Budi Santosa',
    bab: ['Teknik Elektro', 'Mikrokontroler', 'Pemrograman', 'Integrasi Cloud'],
  ),
  Certificate(
    image: 'assets/nps/course-1.png',
    title: 'Pembuatan Dasar Robot',
    name: 'Budi Santosa',
    bab: ['Teknik Elektro', 'Mikrokontroler', 'Pemrograman', 'Integrasi Cloud'],
  ),
  Certificate(
    image: 'assets/nps/course-1.png',
    title: 'Pembuatan Dasar Robot',
    name: 'Budi Santosa',
    bab: ['Teknik Elektro', 'Mikrokontroler', 'Pemrograman', 'Integrasi Cloud'],
  ),
];

//Section Course
final List<CourseSection> section = [
  CourseSection(title: 'Dasar Robotik', total: 3, type: SectionType.materi),
  CourseSection(title: 'Robotik 2', total: 2, type: SectionType.materi),
  CourseSection(title: 'Robotik 3', total: 4, type: SectionType.materi),
  CourseSection(title: 'Kuis Akhir', total: 1, type: SectionType.kuis),
];

//Section Option
List<LessonOption> optLesson = [
  LessonOption(
    image: 'assets/nps/course-1.png', 
    title: 'Dasar Robotic 2'
    ),
  LessonOption(
    image: 'assets/nps/course-2.png', 
    title: 'Dasar Robotic 3'
    ),
  LessonOption(
    image: 'assets/nps/course-3.png', 
    title: 'Dasar Robotic 4'
    ),
  LessonOption(
    image: 'assets/nps/course-4.png', 
    title: 'Dasar Robotic Akhir'
    ),
  ];
