//
//  Home.swift
//  TaskPlanner
//
//  Created by Silvio Colmán on 2023-04-07.
//

import SwiftUI

struct Home: View {
    /// - View Properties
    @State private var currentDay: Date = .init()
    @State private var tasks: [Task] = sampleTasks
    @State private var addNewTask: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            TimelineView()
                .padding(15)
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            HeaderView()
        }
        .fullScreenCover(isPresented: $addNewTask) {
            AddTaskView { task in
                /// - Simplemente añádalo a las tareas
                tasks.append(task)
            }
        }
    }
    
    /// - Vista Cronológica
    @ViewBuilder
    func TimelineView() -> some View {
        ScrollViewReader { proxy in
            let hours = Calendar.current.hours
            let midHour = hours[hours.count / 2]
            VStack {
                ForEach(hours, id: \.self) { hour in
                    TimelineViewRow(hour)
                        .id(hour)
                }
            }
            .onAppear {
                /// - Debido a que la vista de línea de tiempo comienza a las 12 a.m.,queremos que empiece a las 12 p.m., que es mediodía, así que usamos el Proxy ScrollViewReader para ponerlo a mediodía.
                proxy.scrollTo(midHour)
            }
        }
    }
    
    /// - Fila de la vista de línea de tiempo
    @ViewBuilder
    func TimelineViewRow(_ date: Date) -> some View {
        HStack(alignment: .top) {
            Text(date.toString("h a"))
                .ubuntu(14, .regular)
                .frame(width: 45, alignment: .leading)
            
            /// - Filtering Tasks
            let calendar = Calendar.current
            let filteredTasks = tasks.filter {
                /// - Filtrado de tareas en función de la hora y comprobación de si la fecha coincide con el día de la semana seleccionado.
                if let hour = calendar.dateComponents([.hour], from: date).hour,
                   let taskHour = calendar.dateComponents([.hour], from: $0.dateAdded).hour,
                   hour == taskHour && calendar.isDate($0.dateAdded, inSameDayAs: currentDay) {
                    return true
                }
                return false
            }
            
            if filteredTasks.isEmpty {
                Rectangle()
                    .stroke(.gray.opacity(0.5), style: StrokeStyle(lineWidth: 0.5, lineCap: .butt, lineJoin: .bevel,dash: [5], dashPhase: 5))
                    .frame(height: 0.5)
                    .offset(y: 10)
            } else {
                /// - Task View
                VStack(spacing: 10) {
                    ForEach(filteredTasks) { task in
                        TaskRow(task)
                    }
                }
                
            }
        }
        .hAlign(.leading)
        .padding(.vertical, 15)
    }
    
    /// - Task Row
    @ViewBuilder
    func TaskRow(_ task: Task) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(task.taskName.uppercased())
                .ubuntu(16, .regular)
                .foregroundColor(task.taskCategory.color)
            
            if task.taskDescription != "" {
                Text(task.taskDescription)
                    .ubuntu(14, .light)
                    .foregroundColor(task.taskCategory.color.opacity(0.8))
            }
        }
        .hAlign(.leading)
        .padding(12)
        .background {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(task.taskCategory.color)
                    .frame(width: 4)
                Rectangle()
                    .fill(task.taskCategory.color.opacity(0.25))
            }
        }
    }
    
    /// - Vista de Cabecera
    @ViewBuilder
    func HeaderView() -> some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Hoy")
                        .ubuntu(30, .light)
                    
                    Text("Bienvenido, Silvio")
                        .ubuntu(14, .light)
                }
                .hAlign(.leading)
                
                Button {
                    
                    addNewTask.toggle()
                    
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "plus")
                        Text("Añadir Tarea")
                            .ubuntu(15, .regular)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .background {
                        Capsule()
                            .fill(Color("Blue").gradient)
                    }
                    .foregroundColor(.white)
                }

            }
            
            /// - Fecha de hoy en string
            Text(Date().toString("MMM YYYY"))
                .ubuntu(16, .medium)
                .hAlign(.leading)
                .padding(.top, 15)
            
            /// - Fila de la semana actual
            WeekRow()
        }
        .padding(15)
        .background {
            VStack(spacing: 0) {
                Color.white
                
                /// - Fondo Opacidad Gradiente
                /// - Proporciona un bonito efecto degradado en su parte inferior.
                Rectangle()
                    .fill(.linearGradient(colors: [
                        .white,
                        .clear
                    ], startPoint: .top, endPoint: .bottom))
                    .frame(height: 20)
            }
            .ignoresSafeArea()
        }
    }
    
    /// - Fila de la semana
    @ViewBuilder
    func WeekRow() -> some View {
        HStack(spacing: 6) {
            ForEach(Calendar.current.currentWeek) { weekDay in
                let status = Calendar.current.isDate(weekDay.date, inSameDayAs: currentDay)
                VStack(spacing: 6) {
                    Text(weekDay.string.prefix(3))
                        .ubuntu(12, .medium)
                    Text(weekDay.date.toString("dd"))
                        .ubuntu(16, status ? .medium : .regular)
                }
                /// - Resaltar el día activo en ese momento
                .foregroundColor(status ? Color("Blue") : .gray)
                .hAlign(.center)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentDay = weekDay.date
                    }
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, -15)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: View Extensions
/// - Podemos simplemente crear una extensión útil en lugar de utilizar Spacer() cada vez que la vista necesite ser movida en su extremo.
extension View {
    func hAlign(_ aligment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: aligment)
    }
    
    func vAlign(_ aligment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: aligment)
    }
}

// MARK: Date Extension
/// - Con la ayuda de esta extensión, podemos convertir fechas al formato que necesitemos.
extension Date {
    func toString(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

// MARK: Calendar Extension
extension Calendar {
    /// - Devuelve 24 horas en un día
    var hours: [Date] {
        /// - Así, cuando obtenemos el inicio del día, es decir, las 0:00, con ayuda de esto, podemos recuperar fácilmente las fechas de 24 horas.
        let startOfDay = self.startOfDay(for: Date())
        var hours: [Date] = []
        for index in 0..<24 {
            if let date = self.date(byAdding: .hour, value: index, to: startOfDay) {
                hours.append(date)
            }
        }
        
        return hours
    }

    /// - Devuelve la semana actual en formato array
    var currentWeek: [WeekDay] {
        guard let firstWeekDay = self.dateInterval(of: .weekOfMonth, for: Date())?.start
        else { return [] }
        var week: [WeekDay] = []
        for index in 0..<7 {
            /// - La lógica consiste en recuperar el primer día de la semana y, con el método de adición del calendario, obtener las siete fechas siguientes a partir de la fecha de inicio.
            if let day = self.date(byAdding: .day, value: index, to: firstWeekDay) {
                /// - "EEEE" devuelve el símbolo del día de la semana (por ejemplo, lunes) a partir de la fecha dada.
                let weekDaySymbol: String = day.toString("EEEE")
                let isToday = self.isDateInToday(day)
                week.append(.init(string: weekDaySymbol, date: day, isToday: isToday))
            }
        }
        
        return week
    }
    
    /// - Se utiliza para almacenar los datos de cada día de la semana
    /// - Con la ayuda de esto, podemos almacenar e iterar sobre los días de la semana en el método ForEach de SwiftUl.
    struct WeekDay: Identifiable {
        var id: UUID = .init()
        var string: String
        var date: Date
        var isToday: Bool = false
    }
    
}
