//
//  AddTaskView.swift
//  TaskPlanner
//
//  Created by Silvio Colmán on 2023-04-07.
//

import SwiftUI

struct AddTaskView: View {
    /// - Devolución de llamada
    /// - Cuando hagamos clic en el botón "Añadir tarea", se llamará a esto, devolviendo finalmente la tarea que se añadirá a la lista.
    var onAdd: (Task) -> ()
    
    /// - View Properties
    @Environment(\.dismiss) private var dismiss
    @State private var taskName: String = ""
    @State private var taskDescription: String = ""
    @State private var taskDate: Date = .init()
    @State private var taskCategory: Category = .general
    
    /// - Categoría Propiedades de animación
    @State private var animateColor: Color = Category.general.color
    @State private var animate: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Button {
                    
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .contentShape(Rectangle())
                }
                
                Text("Crear Nueva Tarea")
                    .ubuntu(28, .light)
                    .foregroundColor(.white)
                    .padding(.vertical, 15)
                
                TitleView("NOMBRE")
                
                TextField("Hacer un Nuevo Vídeo", text: $taskName)
                    .ubuntu(16, .regular)
                    .tint(.white)
                    .padding(.top, 2)
                
                Rectangle()
                    .fill(.white.opacity(0.7))
                    .frame(height: 1)
                
                TitleView("FECHA")
                    .padding(.top, 15)
                
                HStack(alignment: .bottom, spacing: 12) {
                    HStack(spacing: 12) {
                        Text(taskDate.toString("EEEE dd, MMMM"))
                            .ubuntu(16, .regular)
                        
                        /// - Selector de fecha personalizado
                        Image(systemName: "calendar")
                            .font(.title3)
                            .foregroundColor(.white)
                            .overlay {
                                DatePicker("", selection: $taskDate, displayedComponents: [.date])
                                    /// - ¿Por qué no poner la opacidad a cero? Porque cuando establecemos la opacidad a cero, ocultará la vista y no nos permitirá pulsar sobre ella, pero el modo de fusión no oculta la vista.
                                    .blendMode(.destinationOver)
                            }
                    }
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .fill(.white.opacity(0.7))
                            .frame(height: 1)
                            .offset(y: 5)
                    }
                    
                    HStack(spacing: 12) {
                        Text(taskDate.toString("hh:mm a"))
                            .ubuntu(16, .regular)
                        
                        /// - Selector de fecha personalizado
                        Image(systemName: "clock")
                            .font(.title3)
                            .foregroundColor(.white)
                            .overlay {
                                DatePicker("", selection: $taskDate, displayedComponents: [.hourAndMinute])
                                    /// - ¿Por qué no poner la opacidad a cero? Porque cuando establecemos la opacidad a cero, ocultará la vista y no nos permitirá pulsar sobre ella, pero el modo de fusión no oculta la vista.
                                    .blendMode(.destinationOver)
                            }
                    }
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .fill(.white.opacity(0.7))
                            .frame(height: 1)
                            .offset(y: 5)
                    }
                }
                .padding(.bottom, 15)

            }
            .environment(\.colorScheme, .dark)
            .hAlign(.leading)
            .padding(15)
            .background{
                ZStack {
                    taskCategory.color
                    
                    GeometryReader {
                        let size = $0.size
                        /// - Así que la animación es sencilla: cuando se pulse la nueva categoría, el nuevo color saldrá por la parte inferior arrastrándose como un efecto de escalado, y una vez terminada la animación, se restablecerá a su estado por defecto para que el siguiente color vuelva a salir de la misma forma.
                        Rectangle()
                            .fill(animateColor)
                            .mask {
                                Circle()
                            }
                            .frame(width: animate ? size.width * 2 : 0, height: animate ? size.height * 2 : 0)
                            .offset(animate ? CGSize(width: -size.width / 2, height: -size.height / 2) : size)
                    }
                    .clipped()
                }
                .ignoresSafeArea()
            }
            
            VStack(alignment: .leading, spacing: 10) {
                TitleView("DESCRIPCIÓN", color: .gray)
                
                TextField("Acerca de su Tarea", text: $taskDescription)
                    .ubuntu(16, .regular)
                    .padding(.top, 2)
                
                Rectangle()
                    .fill(.black.opacity(0.2))
                    .frame(height: 1)
                
                TitleView("CATEGORÍA", color: .gray)
                    .padding(.top, 15)
                
                LazyVGrid(columns: Array(repeating: .init(.flexible(),spacing: 20), count: 3)) {
                    ForEach(Category.allCases, id: \.rawValue) { category in
                        Text(category.rawValue.uppercased())
                            .ubuntu(12, .regular)
                            .hAlign(.center)
                            .padding(.vertical, 5)
                            .background {
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                    .fill(category.color.opacity(0.25))
                            }
                            .foregroundColor(category.color)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                /// - Evita los grifos simultáneos
                                guard !animate else { return }
                                animateColor = category.color
                                withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 1, blendDuration: 1)) {
                                    animate = true
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                    animate = false
                                    taskCategory = category
                                }
                            }
                    }
                }
                .padding(.top, 5)
                
                Button {
                    /// - Crear tarea y pasarle el callback
                    let task = Task(dateAdded: taskDate, taskName: taskName, taskDescription: taskDescription, taskCategory: taskCategory)
                    onAdd(task)
                    dismiss()
                    
                } label: {
                    Text("Crear Tarea")
                        .ubuntu(16, .regular)
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                        .hAlign(.center)
                        .background {
                            Capsule()
                                .fill(animateColor.gradient)
                        }
                }
                .vAlign(.bottom)
                .disabled(taskName == "" || animate)
                .opacity(taskName == "" ? 0.6 : 1)

            }
            .padding(15)
        }
        .vAlign(.top)
    }
    @ViewBuilder
    func TitleView(_ value: String, color: Color = .white.opacity(0.7)) -> some View {
        Text(value)
            .ubuntu(12, .regular)
            .foregroundColor(color)
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView { task in
            
        }
    }
}
