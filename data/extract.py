import xml.etree.ElementTree as ET
tree = ET.parse('exporttable.kml')
root = tree.getroot()
document = root[0]


res = ''
for place in document.findall('Placemark'):
    name = place.find('name')
    polygon = place.find('Polygon')
    placemark = ET.Element('Placemark')
    style = ET.Element('styleUrl')
    style.text = 'city'
    placemark.append(style)
    placemark.append(name)
    placemark.append(polygon)
    res_text = ET.dump(placemark)
    if res_text:
        res += '\n\n{}'.format(res_text)

print res
