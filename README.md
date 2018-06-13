# CryptoGraph
CryptoGraph - is an app to observe the most popular cryptocurrencies such as Bitcoin and Etherium. CryptoGraph is taking info from 
the 3 markets(Bitstamp, Bitfinex and CEX) and building a graph that shows asks, bids and last prices of the cryptocurrencies from the 
each market. 
To create this app I used this list of modules:
<ul>
<li>Alamofire - to work with markets' API</li>
<li>DropDown - to create a drop down list with which the user can choose which crypto and from which market he wants to observe the graph</li>
<li>SwiftyJSON - to parse JSON requests into Swift</li>
<li>Charts - to draw the graph</li>
</ul>
Below I will explain how my app works and what functions I needed to create it.
<h2>DropDown</h2>

```swift
@IBOutlet weak var cruptocurButton: UITextField!
var dict = ["ETH", "EOS"]

@IBAction func cryptos(_ sender:Any) {
        let dropDown = DropDown()
        dropDown.anchorView = cruptocurButton
        dropDown.dataSource = dict
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            let text1 = self.cruptocurButton.text
            let x = dropDown.indexForSelectedRow
            self.cruptocurButton.text = dropDown.selectedItem
            self.dict.append(text1!)
            self.dict.remove(at: x!)
            self.reset()
            self.change()
        }
        dropDown.show()
}
```

I will use this func called `cryptos` to show you how to work with the DropDown module. First we need two things: the text field where the
list will appear and the array where we keep our list's values.  The default value of the list is "BTC". Then we create an object of 
DropDown class. We attach the object's view to the text field we created earlier and we do the same with the object's data source. 
The `.selectionAction` method is called when user chooses one of the list's values. Then to make sure that our list won't just forget 
the default value, we append the actual value of the list and delete it from the list's values. Then all we need to do is to call `.show()`
method. I will tell you about `reset()` and `change()` functions later on.
<h2>Getting API</h2>
For example I will use the Bitfinex API. First we need to make a router. So let's look at file called BitfinexRouter.swift: 

```swift
import Foundation
import Alamofire

enum BitfinexRouter: URLRequestConvertible {
    static var baseURL: String = "https://api.bitfinex.com/v1/pubticker/"
    
    case btcusd
    case ethusd
    case eosusd
    case btceur
    case etheur
    case eoseur
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var path: String {
        switch self {
        case .btcusd:
            return "btcusd/"
        case .ethusd:
            return "ethusd/"
        case .eosusd:
            return "eosusd/"
        case .btceur:
            return "btceur/"
        case .etheur:
            return "etheur/"
        case .eoseur:
            return "eoseur/"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = Foundation.URL(string: BitfinexRouter.baseURL)!
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        
        let urlEncoder = URLEncoding.default
        
        switch self {
        case .btcusd,
             .ethusd,
             .eosusd,
             .btceur,
             .etheur,
             .eoseur:
            return try urlEncoder.encode(urlRequest, with: nil)
        }
    }
}

```
In this enumerator we set our URL and regard all the possible cases. In the function called `asURLRequest()` we call the method using 
our URL and the variable `path` which contains the ending of our URL. Then we need to create a structure that will contain our request's 
response. Let's look at file called BitfinexListing.swift:

```swift
import Foundation
import SwiftyJSON

struct ListingItem {
    let mid : String
    let bid : String
    let ask : String
    let last_price: String
    let low : String
    let high: String
    let volume : String
    let timestamp : String
    
    init(with json: JSON) {
        self.mid = json["mid"].stringValue
        self.bid = json["bid"].stringValue
        self.ask = json["ask"].stringValue
        self.last_price = json["last_price"].stringValue
        self.low = json["low"].stringValue
        self.high = json["high"].stringValue
        self.volume = json["volume"].stringValue
        self.timestamp = json["timestamp"].stringValue
    }
}
```
In this structure called `ListingItem` we parse values from JSON response to our corresponding variables using SwiftyJSON module. Next
step is creating a structure which will return our requests. Let's go to API.swift:

```swift
import Foundation
import Alamofire

struct API {
    static func Bitfinex_BTC_USD() -> DataRequest {
        return Alamofire.request(BitfinexRouter.btcusd)
    }
}
```
Structure `API` can contain as much requests as we need. We don't need to create a new file every time we want to make a different request.
And finally we can go to the ViewController:

```swift
var asks : [Double] = []
var bids : [Double] = []
var prices : [Double] = []

func fetchBitfinex_BTC_USDListing() -> DataRequest {
        return API.Bitfinex_BTC_USD().responseJSON { (response) in
            guard let JSONObject = response.value
                else { return }
            
            let json = JSON(JSONObject)
            let listing = ListingItem(with: json)
            self.ask.text = listing.ask
            self.bid.text = listing.bid
            self.last_price.text = listing.last_price
            self.asks.append(Double(listing.ask)!)
            self.bids.append(Double(listing.bid)!)
            self.prices.append(Double(listing.last_price)!)
            self.updateGraph()
        }
    }
```
With this function we make a request to get info from the Bitfinex market about Bitcoin in dollars. First we get JSON response using the 
corresponding method from the API.swift and parse it using our earlier created structure `ListingItem`. Then we append our ask, bid and 
price to the outer arrays and call the `updateGraph()` function which I will talk about in the next step.
<h2>Graph</h2>

```swift
 func updateGraph(){
        var lineChartEntry1  = [ChartDataEntry]() 
        var lineChartEntry2  = [ChartDataEntry]()
        var lineChartEntry3  = [ChartDataEntry]()
        
        for i in 0..<asks.count {
            let value = ChartDataEntry(x: Double(i), y: asks[i])
            lineChartEntry1.append(value)
        }
        
        for i in 0..<bids.count {
            let value = ChartDataEntry(x: Double(i), y: bids[i])
            lineChartEntry2.append(value)
        }
        
        for i in 0..<prices.count  {
            let value = ChartDataEntry(x: Double(i), y: prices[i])
            lineChartEntry3.append(value)
        }
        
        let line1 = LineChartDataSet(values: lineChartEntry1, label: "Asks")
        line1.colors = [NSUIColor.red]
        line1.circleRadius = 2
        line1.circleColors = [NSUIColor.red]
        
        let line2 = LineChartDataSet(values: lineChartEntry2, label: "Bids")
        line2.colors = [NSUIColor.green]
        line2.circleRadius = 2
        line2.circleColors = [NSUIColor.green]
        
        let line3 = LineChartDataSet(values: lineChartEntry3, label: "Last Prices")
        line3.colors = [NSUIColor.black]
        line3.circleRadius = 2
        line3.circleColors = [NSUIColor.black]
        
        let data = LineChartData()
        data.addDataSet(line1)
        data.addDataSet(line2)
        data.addDataSet(line3)
        
        let xAxis = graph.xAxis
        xAxis.drawLabelsEnabled = false
        xAxis.drawGridLinesEnabled = false
        
        let yAxis = graph.rightAxis
        yAxis.drawLabelsEnabled = false
        
        graph.isUserInteractionEnabled = false
        graph.data = data
        graph.chartDescription?.text = ""
    }
```
First we fill our graph data arrays with values from the outer arrays, that we saw earlier. Than we create lines that correspond 
to asks, bids and last prices. Then after some tuning with the graph settings we finally attach our data to graph data and make 
the graph work. 

```swift
 func reset() {
        asks.removeAll()
        bids.removeAll()
        prices.removeAll()
    }
```
Function reset is used to clear the array values when the user changes list's values.
<h2>Time Interval</h2>
The last thing that we need to do is to cycle our app to make a request every 5 seconds. To do this we will use a built-in class 
called Timer() and set the interval in the override function:

```swift
var timer = Timer()

 override func viewDidLoad() {
        super.viewDidLoad()
        change()
        
        timer = Timer(timeInterval: 5.0, target: self, selector: #selector(change), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.defaultRunLoopMode)
    }

```
Function `change()` just calls the neeeded request depended on which currencies and on which market the user wants to see and calls 
the function `updateGraph()` that we have already seen.

```swift
@objc func change() {
        currentRequest?.cancel()
        if cruptocurButton.text == "BTC" && stock.text == "Bitfinex" && value.text == "USD" {
            currentRequest = fetchBitfinex_BTC_USDListing()
        }
        ...
}
```
