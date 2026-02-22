from models import Student, Classroom
import analytics
import utils

def main_menu():
    classroom = Classroom()
    all_students = utils.load_from_csv()
    for s in all_students:
        classroom.add_student(s)

    while True:
        print("\n--- Student Performance Analyzer ---")
        print("1. Add Student")
        print("2. View Students Rankings")
        print("3. Search fo a Student")
        print("4. Remove Student")
        print("5. View Class Analytics")
        print("6. Save & Exit")
        print("-----------------------------------")
        
        choice = input("Select an option: ")

        if choice == '1':
            sid = utils.valid_input("Enter Student ID: ", int)
            name = utils.valid_input("Enter Student Name: ")
            grades_raw = utils.valid_input("Enter grades (separated by space): ")

            grades = []
            for g_str in grades_raw.split():
                try:
                    g = float(g_str)
                    if Student.validate_grade(g):
                        grades.append(g)
                    else:
                        print(f"Skipping invalid grade: {g}")
                except ValueError:
                    print(f"Skipping non-numeric grade: {g_str}")

            if grades:
                new_student = Student(sid, name, grades)
                classroom.add_student(new_student)
                print("Student added successfully!")
            else:
                print("No valid grades entered. Student not added.")


        elif choice == '2':
            print("\n--- Student Rankings ---")
            ranked = analytics.rank_students(classroom)
            for s in ranked:
                print(f"ID: {s.student_id} | Name: {s.name} | Avg: {s.calculate_average():.2f} | {s.get_category()}")

        elif choice == '3':
            sid = input("Enter ID to search: ")
            s = classroom.search_student(sid)
            if s:
                print(f"Found: {s.name}, Average: {s.calculate_average():.2f}")
            else:
                print("Student not found.")

        elif choice == '4':
            sid = input("Enter ID to remove: ")
            if classroom.remove_student(sid):
                print("Student removed.")
            else:
                print("Student not found.")

        elif choice == '5':
            top = analytics.get_top_performer(classroom)
            low = analytics.get_lowest_performer(classroom)
            dist = analytics.get_grade_distribution(classroom)
            
            print(f"\nClass Average: {classroom.calculate_class_average():.2f}")
            if top: print(f"Top Performer: {top.name} ({top.calculate_average():.2f})")
            if low: print(f"Lowest Performer: {low.name} ({low.calculate_average():.2f})")
            print("Distribution:", dist)

        elif choice == '6':
            utils.save_to_csv(classroom)
            print("Data saved. Goodbye!")
            break
        else:
            print("Invalid choice, try again.")

if __name__ == "__main__":
    main_menu()