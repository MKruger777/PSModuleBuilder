
class Tree {
 
    [String]$Species
    [int32]$Height
    [Boolean]$Deciduous = $True
 
    Tree () {}
    Tree ([String]$Species, [int32]$Height)
    {
        $this.Species = $Species
        $this.Height = $Height
    }
 
    [int32] Grow ([int32]$Amount)
    {
        $this.Height += $Amount
        return $this.Height
    }
}
