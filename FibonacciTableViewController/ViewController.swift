//
//  ViewController.swift
//  FibonacciTableViewController
//
//  Created by Raphael Berendes on 21.06.19.
//  Copyright © 2019 Raphael Berendes. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var numberOfRows = 99999 // Just "infinite" rows to begin with
    let serialQueue = DispatchQueue(label: "serialQueue")
    var tableData: [UInt64] = [1, 1, 2]
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let n = indexPath.row
        var fibonacci: UInt64 = 0
        
        if n < tableData.count {
            fibonacci = tableData[n]
            cell.textLabel?.text = "\(fibonacci)"
            
        } else {
            
            serialQueue.async {
                fibonacci = self.fibonacci(n: n)
                
                DispatchQueue.main.async {
                    if fibonacci == 0 {
                        // Adjust number of rows to correct amount
                        tableView.reloadData()
                    }

                    cell.textLabel?.text = "\(fibonacci)"
                }
            }
        }
        
        return cell
    }
    
    func fibonacci(n: Int) -> UInt64 {
        
        var f: UInt64 = 0
        
        if n < tableData.count {
            f = tableData[n]
        } else {
            
            // This overflow checker is really nice. Didn't know it existed.
            let (sum, didOverflow): (UInt64, Bool) = fibonacci(n: n-2).addingReportingOverflow(fibonacci(n: n-1))
            
            if didOverflow {
                
                /* Adjust number of rows to correct amount.
                 * Returning 0 indicates that we have to reload the table view.
                 */
                f = 0
                numberOfRows = n
                
            } else {
                f = sum
                tableData.append(f)
            }
        }
        
        return f
    }
    
}

