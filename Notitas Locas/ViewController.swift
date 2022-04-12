//
//  ViewController.swift
//  Notitas Locas
//
//  Created by Iree García on 11/04/22.
//

import UIKit

class ViewController: UIViewController {
   
   @IBOutlet var tableView: UITableView!
   var notes = [Note]()

   override func viewDidLoad() {
      super.viewDidLoad()
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      // extraer notas
      notes = Note.allNotes()
      tableView.reloadData()
   }
   
//   @IBAction func addNote(_ sender: Any) {
//      performSegue(withIdentifier: "note detail", sender: self)
//   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      super.prepare(for: segue, sender: sender)
      if let cell = sender as? UITableViewCell,
         let indexPath = tableView.indexPath(for: cell),
         let controller = segue.destination as? NoteDetailViewController {
         controller.noteIndex = indexPath.row
      }
   }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return notes.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      let note = notes[indexPath.row]
      cell.textLabel?.text = note.title
      cell.detailTextLabel?.text = note.detail
      return cell
   }
}
