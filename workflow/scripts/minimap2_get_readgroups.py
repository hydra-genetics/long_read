# workflow/scripts/minimap2_get_readgroups.py
import subprocess

def extract_rg_lines(bam_file):
    """
    Extracts all @RG lines from a BAM file using samtools and returns them as a list.

    Args:
    - bam_file (str): Path to the input BAM file.

    Returns:
    - rg_lines (list of str): List of @RG lines extracted from the BAM file.
    """
    # Command to extract header lines from the BAM file using samtools
    cmd = ['samtools', 'view', '-H', bam_file]

    try:
        # Run the command and capture the output
        process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        stdout, stderr = process.communicate()
        
        if process.returncode != 0:
            print(f"An error occurred while running samtools: {stderr.decode('utf-8')}")
            return []
        
        if not stdout:
            print("No output was captured from samtools. Please check if the BAM file is valid.")
            return []
        
        # Extract @RG lines
        rg_lines = [line for line in stdout.decode('utf-8').split('\n') if line.startswith('@RG')]
        
        if not rg_lines:
            print("No RG lines found")
        
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        return []

    return rg_lines

