import glob
import os.path

print("---------------- generating TextGrid contents ----------------")
for dur in glob.glob("data/segments/all/*.dur"):
    textGrid = dur[:dur.index('.')] + '.TextGrid'
    if os.path.isfile(textGrid):
        total = float(0.0)
        segments = []
        # count segment partial sums
        with open(dur, 'r') as durfile:
            for line in durfile.readlines():
                fields = line.split()
                duration = fields[0]
                text = fields[1]
                xmin = total
                total += float(duration)
                xmax = total
                segments.append((text, xmin, xmax))
        outbody = []
        outheader = []
        # read TextGrid for output header, then construct body of intervals
        with open(textGrid, 'r') as txtfile:
            print("Producing " + textGrid + "...")
            lines = txtfile.readlines()
            outheader = lines[:13]
            indent1 = " " * 8
            indent2 = " " * 12
            line_end_xmax = outheader[-1]
            end_xmax = line_end_xmax[line_end_xmax.index('=')+1:].strip()
            line_size = indent1 + "intervals: size = " + str(len(segments))
            outbody = [line_size]
            for i, (text, xmin, xmax) in enumerate(segments):
                line_index = indent1 + "intervals [" + str(i + 1) + "]:"
                line_xmin = indent2 + "xmin = " + str(xmin)
                if i == 0:
                    line_xmin = indent2 + "xmin = 0"
                line_xmax = indent2 + "xmax = " + str(xmax)
                if i == len(segments) - 1:
                    line_xmax = indent2 + "xmax = " + end_xmax
                line_text = indent2 + "text = \"" + text + "\""
                outbody.extend([line_index, line_xmin, line_xmax, line_text])
        # output segmented TextGrid
        with open(textGrid, 'w') as txtfile:
            for line in outheader:
                txtfile.write(line)
            for line in outbody:
                txtfile.write(line + "\n")
