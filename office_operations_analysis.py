import pandas as pd

df = pd.read_csv("Dataset/office_operations_data.csv",
                 parse_dates=["Request_Date","Due_Date","Completion_Date"])

completed = df[df["Status"] == "Completed"].copy()
on_time_rate = round((completed["Delay_Days"] == 0).mean() * 100, 2)

print("Total tasks:", len(df))
print("Completed:", (df["Status"]=="Completed").sum())
print("Pending:", (df["Status"]=="Pending").sum())
print("In Progress:", (df["Status"]=="In Progress").sum())
print("Cancelled:", (df["Status"]=="Cancelled").sum())
print("On-time completion %:", on_time_rate)
print("Average delay:", round(completed["Delay_Days"].mean(), 2))

department = df.groupby("Department").agg(
    Total_Tasks=("Task_ID","count"),
    Completed=("Status", lambda x: (x=="Completed").sum()),
    Avg_Delay=("Delay_Days","mean")
).round(2)
department["Completion_Rate_%"] = (department["Completed"]/department["Total_Tasks"]*100).round(2)
print("\nDepartment performance:\n", department)

task_type = df.groupby("Task_Type").agg(
    Total=("Task_ID","count"),
    Completed=("Status", lambda x: (x=="Completed").sum()),
    Avg_Delay=("Delay_Days","mean")
).round(2)
task_type["Completion_Rate_%"] = (task_type["Completed"]/task_type["Total"]*100).round(2)
print("\nTask type performance:\n", task_type)
