//
//  ViewController.swift
//  YandexWeather
//
//  Created by Евгений Соловьев on 27.07.2021.
//

import UIKit

class ViewController: UITableViewController {
    var response = [Response]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let session = URLSession(configuration: .default)
        let header: [String: String] = ["X-Yandex-API-Key": "533d98c4-4cce-44bf-8693-ab09202733f3"]
        var url = URL(string: "https://api.weather.yandex.ru/v2/forecast?lat=55.755826&lon=37.6173&extra=true&lang=ru_RU&hours=false&limit=5")
        if let safeURL = url {
            var request = URLRequest(url: safeURL)
            request.allHTTPHeaderFields = header
            let task = session.dataTask(with: request) { data, response, error in
                if error == nil {
                    if let safeData = data {
                        self.parse(json: safeData)
                    }
                } else {
                    let ac = UIAlertController(title: "Error", message: "Connection error, try again", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                }
            }
            task.resume()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(response.count)
        return response.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Москва"
        cell.detailTextLabel?.text = ("\(response[indexPath.row].fact.conditionName), температура: \(response[indexPath.row].fact.temp) \u{2103}")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonResponse = try? decoder.decode(Response.self, from: json) {
            response.append(jsonResponse)
            print(response[0].fact.temp)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            print("JSON Decoder Error")
        }
    }
}

//extension ViewController {
//
//}
