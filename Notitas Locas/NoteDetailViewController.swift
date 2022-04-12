//
//  NoteDetailViewController.swift
//  Notitas Locas
//
//  Created by Iree García on 11/04/22.
//

import UIKit

class NoteDetailViewController: UIViewController {
   @IBOutlet var textView: UITextView!
   var noteIndex: Int?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      // cargar datos iniciales
      if let index = noteIndex, let note = Note.getNote(at: index) {
         navigationItem.title = note.title
         textView.text = note.rawText
      } else {
         navigationItem.title = "Nueva nota"
      }
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      let rawText = textView.text ?? ""
      Note.saveNote(at: noteIndex, rawText: rawText)
   }
}

// MARK: - Utilerias

extension Note {
   static let JSONArrayKey = "notes"
   
   static func getNote(at index: Int) -> Note? {
      // obtener arreglo de jsons
      if let jsonArray = UserDefaults.standard.array(forKey: JSONArrayKey) as? [String],
         jsonArray.count > index {
         // extraer nota
         let json = jsonArray[index]
         if let jsonData = json.data(using: .utf8),
            let note = try? JSONDecoder().decode(Note.self, from: jsonData) {
            return note
         }
      }
      return nil
   }
   
   static func saveNote(at index: Int?, rawText: String) {
      // analizar y procesar texto
      if rawText.isEmpty { return }
      
      var components = rawText.split(separator: "\n")
      let title, detail: String
      if components.count > 1 {
         title = String(components[0])
         detail = components.dropFirst().joined(separator: "\n")
      } else {
         components = rawText.split(separator: " ")
         if components.count > 2 {
            title = components.prefix(2).joined(separator: " ")
            detail = components.dropFirst(2).joined(separator: " ")
         } else {
            title = rawText
            detail = ""
         }
      }
      // guardar nota
      let note = Note(title: title, detail: detail, rawText: rawText)
      let jsonEncoder = JSONEncoder()
      if let jsonData = try? jsonEncoder.encode(note),
         let json = String(data: jsonData, encoding: .utf8) {
         
         var jsonArray = UserDefaults.standard.array(forKey: JSONArrayKey) as? [String] ?? []
         if let index = index, index < jsonArray.count {
            jsonArray[index] = json
         } else {
            jsonArray.append(json)
         }
         UserDefaults.standard.set(jsonArray, forKey: JSONArrayKey)
      }
   }
   
   static func allNotes() -> [Note] {
      if let jsonArray = UserDefaults.standard.array(forKey: JSONArrayKey) as? [String] {
         // convertir cada json en nota
         return jsonArray.compactMap({ json in
            if let jsonData = json.data(using: .utf8),
               let note = try? JSONDecoder().decode(Note.self, from: jsonData) {
               return note
            }
            return nil
         })
      }
      return []
   }
}
