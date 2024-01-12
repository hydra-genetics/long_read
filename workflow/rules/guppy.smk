__author__ = "Nina Hollfelder"
__copyright__ = "Copyright 2023, Nina Hollfelder"
__email__ = "nina_hollfelder@scilifelab.uu.se"
__license__ = "GPL-3"

basecaller = config.get("basecaller", None)

if basecaller is None:
    sys.exit("basecaller missing from config, valid options: gpu or cpu")

elif basecaller == "gpu":
    rule guppy_basecaller_gpu:
        input:
            fast5dir="long_read/fast5",
            #configfile=config["guppy_basecaller_gpu"]["configuration_file"],
        output:
            seqsum="long_read/guppy/sequencing_summary.txt",
            fastq="long_read/guppy/guppy_basecaller.gpu.fastq",
        params:
            extra=config.get("guppy_basecaller_gpu", {}).get("extra", ""),
            gpu="cuda:0",
            chunks=config.get("guppy_basecaller_gpu", {}).get("chunks", "20"),
            outdir=lambda wildcards, output: os.path.dirname(output[0]),
        log:
            "long_read/guppy/guppy_basecaller_gpu.log",
        benchmark:
            repeat(
                "long_read/guppy/guppy_basecaller_gpu.benchmark.tsv",
                config.get("guppy_basecaller_gpu", {}).get("benchmark_repeats", 1),
            )
        threads: config.get("guppy_basecaller_gpu", {}).get("threads", config["default_resources"]["threads"])
        resources:
            mem_mb=config.get("guppy_basecaller_gpu", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
            mem_per_cpu=config.get("guppy_basecaller_gpu", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
            partition=config.get("guppy_basecaller_gpu", {}).get("partition", config["default_resources"]["partition"]),
            threads=config.get("guppy_basecaller_gpu", {}).get("threads", config["default_resources"]["threads"]),
            time=config.get("guppy_basecaller_gpu", {}).get("time", config["default_resources"]["time"]),
        container:
            config.get("guppy_basecaller_gpu", {}).get("container", config["default_container"])
        message:
            "{rule}: guppy basecalling fast5 files using GPU"
        script:
            "guppy_basecaller -i {input.fast5dir} "
            "-s {params.outdir} "
            "-c {input.configfile} "
            "--device {params.gpu} "
            "-chunks_per_caller {params.chunks} "
            " {params.extra} &> {log} "

elif basecaller == "cpu":
    rule guppy_basecaller_cpu:
        input:
            fast5dir="long_read/fast5",
            #configfile=config["guppy_basecaller_cpu"]["configuration_file"],
        output:
            seqsum="long_read/guppy/sequencing_summary.txt",
            fastq="long_read/guppy/guppy_basecaller_cpu.fastq",
        params:
            extra=config.get("guppy_basecaller_cpu", {}).get("extra", ""),
            num_caller=config.get("guppy_basecaller_cpu", {}).get("num_callers", "1"),
            outdir=lambda wildcards, output: os.path.dirname(output[0]),
        log:
            "long_read/guppy/guppy_basecaller_cpu.log",
        benchmark:
            repeat(
                "long_read/guppy/guppy_basecaller_cpu.benchmark.tsv",
                config.get("guppy_basecaller_cpu", {}).get("benchmark_repeats", 1),
            )
        threads: config.get("guppy_basecaller_cpu", {}).get("threads", config["default_resources"]["threads"])
        resources:
            mem_mb=config.get("guppy_basecaller_cpu", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
            mem_per_cpu=config.get("guppy_basecaller_cpu", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
            partition=config.get("guppy_basecaller_cpu", {}).get("partition", config["default_resources"]["partition"]),
            threads=config.get("guppy_basecaller_cpu", {}).get("threads", config["default_resources"]["threads"]),
            time=config.get("guppy_basecaller_cpu", {}).get("time", config["default_resources"]["time"]),
        container:
            config.get("guppy_basecaller_cpu", {}).get("container", config["default_container"])
        message:
            "{rule}: guppy basecalling fast5 files using cpu"
        script:
            "guppy_basecaller -i {input.fast5dir} "
            "-s {params.outdir} "
            "-c {input.configfile} "
            "--num_callers {params.num_caller} "
            "--num_cpu_threads_per_caller {resources.threads} "
            " {params.extra} &> {log} "

else:
    sys.exit("basecaller missing from config, valid options: gpu or cpu")
