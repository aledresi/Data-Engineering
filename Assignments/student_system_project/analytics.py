


def get_top_performer(classroom):
    return max(classroom.students, key=lambda s: s.calculate_average())


def get_lowest_performer(classroom):
    return min(classroom.students, key=lambda s: s.calculate_average())


def rank_students(classroom):
    return sorted(classroom.students, key=lambda s: s.calculate_average(), reverse=True)


def get_grade_distribution(classroom):
    distribution = {"A+": 0, "A": 0, "B": 0, "C": 0, "F": 0}
    for student in classroom.students:
        cat = student.get_category()
        distribution[cat] += 1
    return distribution