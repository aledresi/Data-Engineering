import csv
from models import Student

#Write#
def save_to_csv(classroom, filename="data.csv"):
    try:
        with open(filename, mode='w', newline='') as file:
            writer = csv.writer(file)
            for s in classroom.students:
                writer.writerow([s.student_id, s.name, ",".join(map(str, s.grades))])
        print(f"Successfully saved data to {filename}")
    except Exception as e:
        print(f"Error: Could not save data: {e}")


#read#
def load_from_csv(filename="data.csv"):
    students = []
    try:
        with open(filename, mode='r') as file:
            reader = csv.reader(file)
            for row in reader:
                if row:
                    student = Student.from_csv_row(row)
                    if student:
                        students.append(student)
    except Exception as e:
        print(f"could not load data: {e}")
    return students


#validation#
def valid_input(prompt, data_type=str):
    while True:
        try:
            return data_type(input(prompt))
        except ValueError:
            print(f"Invalid input. Please enter a valid {data_type.__name__}.")