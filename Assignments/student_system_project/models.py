class Student:
    def __init__(self, student_id, name, grades):
        self.__student_id = student_id
        self.__name = name
        self.__grades = grades if grades else []

    @property
    def student_id(self):
        student_id = self.__student_id
        return student_id

    @property
    def name(self):
        name = self.__name
        return name

    @property
    def grades(self):
        grades = self.__grades
        return grades

    def calculate_average(self):
        return sum(self.grades) / len(self.grades)

    def get_category(self):
        avg = self.calculate_average()
        if avg >= 90: return "A+"
        if avg >= 80: return "A"
        if avg >= 70: return "B"
        if avg >= 60: return "C"
        return "F"

    @classmethod
    def from_csv_row(cls, row):
        try:
            sid, name, grades_str = row
            grades = [float(g) for g in grades_str.split(",") if g.strip()]
            return cls(sid, name, grades)
        except (ValueError, IndexError) as e:
            print(f"Error parsing student data: {e}")
            return None

    @staticmethod
    def validate_grade(grade):
        return 0 <= grade <= 100


class Classroom:
    def __init__(self):
        self.students = []

    def add_student(self, student):
        self.students.append(student)

    def remove_student(self, student_id):
        self.students = [s for s in self.students if s.student_id != student_id]

    def search_student(self, student_id):
        for student in self.students:
            if student.student_id == student_id:
                return student

    def calculate_class_average(self):
        total_avg = sum(s.calculate_average() for s in self.students)
        return total_avg / len(self.students)